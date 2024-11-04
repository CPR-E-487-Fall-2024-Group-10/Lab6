#include "Dense.h"

#include <iostream>

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

#ifdef ZEDBOARD
#include "xllfifo_hw.h"
#include "xparameters.h"
#include "xil_io.h"
#endif

namespace ML {

    void DenseLayer::computeNaive(const LayerData& dataIn) const {
        // number of output feature maps
        int numOfMaps = getOutputData().getParams().dims.at(0);
        // number of input feature maps
        int numIfMaps = dataIn.getParams().dims.at(0);

        for(int n = 0; n < 1; n++) {
            // iterate for each output feature map (channel)
            for(int m = 0; m < numOfMaps; m++) {
                // iterate for each input feature map
                float sum = 0.0f;
                for(int c = 0; c < numIfMaps; c++) {
                    float i = dataIn.get<fp32>((n * numIfMaps) + c);
                    float f = getWeightData().get<fp32>((n * numIfMaps * numOfMaps) + (c * numOfMaps) + m);

                    sum += i * f;
                }

                if(doActivation) {
                    getOutputData().get<fp32>((n * numOfMaps) + m) = relu(sum + getBiasData().get<fp32>(m));
                } else {
                    getOutputData().get<fp32>((n * numOfMaps) + m) = sum + getBiasData().get<fp32>(m);
                    }
            }
        }
    }

    void DenseLayer::computeThreaded(const LayerData& dataIn) const {
        // TODO
    }

    void DenseLayer::computeTiled(const LayerData& dataIn) const {
        // TODO
    }

    void DenseLayer::computeSIMD(const LayerData& dataIn) const {
        // TODO
    }

    void DenseLayer::computeAccelerated(const LayerData& dataIn, const QuantType quantType) const {
        // number of output feature maps
        int numOfMaps = getOutputData().getParams().dims.at(0);
        // number of input feature maps
        int numIfMaps = dataIn.getParams().dims.at(0);

        // quantization code
        float input_max_diff = 0.0f;
        float input_avg = 0.0f;
        float input_min = 1.0f;
        float input_max = 0.0f;
        for(int i = 0; i < numIfMaps; i++) {
            input_avg += dataIn.get<fp32>(i);

            if(dataIn.get<fp32>(i) > input_max) {
                input_max = dataIn.get<fp32>(i);
            }

            if(dataIn.get<fp32>(i) < input_min) {
                input_min = dataIn.get<fp32>(i);
            }
        }

        input_avg /= numIfMaps;

        for(int i = 0; i < numIfMaps; i++) {
            if(fabs(dataIn.get<fp32>(i) - input_avg) > input_max_diff) {
                input_max_diff = fabs(dataIn.get<fp32>(i) - input_avg);
            }
        }

        float quantNumerator; // numerator for quantization calculations
        #ifdef ZEDBOARD
        uint8_t shiftAmt; // how much to shift bits when writing to FIFO
        int32_t quantSelect; // select to tell hardware what quantization to use
        uint8_t packAmt; // how many weights and data we can pack at a time
        uint8_t andMask;
        #endif
        switch(quantType) {
            case Layer::QuantType::INT2:
                quantNumerator = 1.0f;
                #ifdef ZEDBOARD
                shiftAmt = 2;
                quantSelect = 0x80;
                packAmt = 4;
                andMask = 0x03;
                #endif
                break;

            case Layer::QuantType::INT4:
                quantNumerator = 7.0f;
                #ifdef ZEDBOARD
                shiftAmt = 4;
                quantSelect = 0x40;
                packAmt = 2;
                andMask = 0x0F;
                #endif
                break;

            case Layer::QuantType::INT8:
                quantNumerator = 127.0f;
                #ifdef ZEDBOARD
                shiftAmt = 8;
                quantSelect = 0x00;
                packAmt = 1;
                andMask = 0xFF;
                #endif
                break;

            default: // shouldn't happen, just use 8 bit
                quantNumerator = 127.0f;
                #ifdef ZEDBOARD
                shiftAmt = 8;
                quantSelect = 0x00;
                packAmt = 1;
                andMask = 0xFF;
                #endif
                break;
        }

        float input_scale = quantNumerator / input_max_diff;

        float weight_max = getWeightData().get<fp32>(0);
        for(int i = 0; i < numIfMaps * numOfMaps; i++) {
            if(fabs(getWeightData().get<fp32>(i)) > fabs(weight_max)) {
                weight_max = fabs(getWeightData().get<fp32>(i));
            }
        }

        float weight_scale = quantNumerator / fabs(weight_max);

        int8_t zero_point = static_cast<int8_t>(-round(input_avg * input_scale));
    
        // quantize input
        LayerParams quantizedInputParams(1, dataIn.getParams().dims);
        LayerData quantizedInputData(quantizedInputParams);
        quantizedInputData.allocData();
        for(int i = 0; i < numIfMaps; i++) {
            quantizedInputData.get<int8_t>(i) = static_cast<int8_t>(static_cast<int16_t>(round(dataIn.get<fp32>(i) * input_scale)) + zero_point);
        }

        // quantize weights
        LayerParams quantizedWeightParams(1, getWeightData().getParams().dims);
        LayerData quantizedWeightData(quantizedWeightParams);
        quantizedWeightData.allocData();
        for(int i = 0; i < numIfMaps * numOfMaps; i++) {
            quantizedWeightData.get<int8_t>(i) = static_cast<int8_t>(round(getWeightData().get<fp32>(i) * weight_scale));
        }

        // quantize biases
        float bias_scale = weight_scale * input_scale;

        LayerParams quantizedBiasParams(sizeof(int32_t), getBiasData().getParams().dims);
        LayerData quantizedBiasData(quantizedBiasParams);
        quantizedBiasData.allocData();
        for(unsigned long i = 0; i < getBiasData().getParams().dims.at(0); i++) {
            quantizedBiasData.get<int32_t>(i) = static_cast<int32_t>(round(getBiasData().get<fp32>(i) * bias_scale));
        }

        for(int n = 0; n < 1; n++) {
            // iterate for each output feature map (channel)
            for(int m = 0; m < numOfMaps; m++) {
                #ifdef ZEDBOARD
                int32_t weightSum = 0;

                int32_t writeData = 0;
                int32_t numPacked = 0;
                for(int c = 0; c < numIfMaps; c++) {
                    writeData <<= shiftAmt;
                    writeData |= quantizedInputData.get<int8_t>((n * numIfMaps) + c) & andMask;
                    writeData <<= shiftAmt;
                    writeData |= quantizedWeightData.get<int8_t>((n * numIfMaps * numOfMaps) + (c * numOfMaps) + m) & andMask;

                    numPacked++;

                    if(numPacked == packAmt) {
                        writeData |= (quantSelect << 16);

                        Xil_Out32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_TDFD_OFFSET, writeData);

                        numPacked = 0;
                        writeData = 0;
                    }

                    weightSum += quantizedWeightData.get<int8_t>((n * numIfMaps * numOfMaps) + (c * numOfMaps) + m);
                }

                // send any extra
                if(numPacked > 0) {
                    writeData |= (quantSelect << 16);

                    Xil_Out32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_TDFD_OFFSET, writeData);
                }

                // set length of transmit
                int32_t txLen = (numIfMaps / packAmt) * 4; // length is number of elements times 4 (since it is in bytes) divided by number per 32 bits
                if(numPacked != 0) txLen += 4; // handle case where not evenly divisible

                Xil_Out32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_TLF_OFFSET, txLen);

                while (Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RDFO_OFFSET) == 0);

                uint32_t readLen = Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RLF_OFFSET);

                int32_t result = (int32_t) Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RDFD_OFFSET);
                readLen -= 4;

                // shouldn't happen, MAC only ever sends a single word
                while(readLen > 0) int32_t junk = Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RDFD_OFFSET);

                #else

                // iterate for each input feature map
                int32_t result = 0;
                int32_t weightSum = 0;
                for(int c = 0; c < numIfMaps; c++) {
                    int32_t i = quantizedInputData.get<int8_t>((n * numIfMaps) + c);
                    int32_t f = quantizedWeightData.get<int8_t>((n * numIfMaps * numOfMaps) + (c * numOfMaps) + m);

                    result += i * f;
                    weightSum += f;
                }

                #endif

                // int32_t activation;
                float activation;
                if(doActivation) {
                    // activation = relu(sum + quantizedBiasData.get<int8_t>(m), zero_point);
                    activation = relu(static_cast<float>((result + quantizedBiasData.get<int32_t>(m)) - (zero_point * weightSum)) / (input_scale * weight_scale));
                } else {
                    activation = static_cast<float>((result + quantizedBiasData.get<int32_t>(m)) - (zero_point * weightSum)) / (input_scale * weight_scale);
                }

                // getOutputData().get<fp32>((n * numOfMaps) + m) = static_cast<float>(activation - zero_point) / input_scale;
                getOutputData().get<fp32>((n * numOfMaps) + m) = activation;

            }
        }    
    }

}