#include "Dense.h"

#include <iostream>

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

#ifdef ZEDBOARD
#include "xparameters.h"
#include "xil_io.h"
#include "MLP.h"
#endif

namespace ML {

    void DenseLayer::computeNaive(const LayerData& dataIn) const {
        // number of output feature maps
        // int numOfMaps = getOutputData().getParams().dims.at(0);
        // // number of input feature maps
        // int numIfMaps = dataIn.getParams().dims.at(0);

        // for(int n = 0; n < 1; n++) {
        //     // iterate for each output feature map (channel)
        //     for(int m = 0; m < numOfMaps; m++) {
        //         // iterate for each input feature map
        //         float sum = 0.0f;
        //         for(int c = 0; c < numIfMaps; c++) {
        //             float i = dataIn.get<fp32>((n * numIfMaps) + c);
        //             float f = getWeightData().get<fp32>((n * numIfMaps * numOfMaps) + (c * numOfMaps) + m);

        //             sum += i * f;
        //         }

        //         if(doActivation) {
        //             getOutputData().get<fp32>((n * numOfMaps) + m) = relu(sum + getBiasData().get<fp32>(m));
        //         } else {
        //             getOutputData().get<fp32>((n * numOfMaps) + m) = sum + getBiasData().get<fp32>(m);
        //             }
        //     }
        // }
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

        // find the scale to dequantize this layer and quantize for next
        // this is kind of long-winded, but wanted to be sure bits weren't going to be lopped off unintentionally
        int64_t finalScale = next_input_scale;
        finalScale <<= 32;
        finalScale /= input_scale;
        finalScale /= weight_scale;

        for(int n = 0; n < 1; n++) {
            #ifdef ZEDBOARD
            // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) & ~(MLP_CTRLB_SWAP_ACTIVATIONS));
            memcpy_dma(MLP_INPUTS, dataIn.getRaw<int8_t>(), numIfMaps);
            // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) | (MLP_CTRLB_SWAP_ACTIVATIONS));

            int diff_fw = 1;
            int diff_fh = 1;
            int diff_fc = 1;
            int diff_ow = (-numIfMaps) + 1;

            // Configure HW accelerator (no idea if this is correct)
            Xil_Out32(MLP_FILTER_W, 1);
            Xil_Out32(MLP_FILTER_H, 1);
            Xil_Out32(MLP_FILTER_C, numOfMaps);
            Xil_Out32(MLP_OUTPUT_W, 1);
            Xil_Out32(MLP_OUTPUT_H, 1);
            Xil_Out32(MLP_INPUT_END_DIFF_FW, diff_fw);
            Xil_Out32(MLP_INPUT_END_DIFF_FH, diff_fh);
            Xil_Out32(MLP_INPUT_END_DIFF_FC, diff_fc);
            Xil_Out32(MLP_INPUT_END_DIFF_OW, diff_ow);
            Xil_Out32(MLP_OUTPUT_ELEMENTS_PER_CHANNEL, 1);
            Xil_Out32(MLP_OUTPUT_INITIAL_OFFSET, 0); // TODO this will change once we are keeping data in accelerator
            Xil_Out32(MLP_Q_SCALE, finalScale); // Quantization scaling
            Xil_Out32(MLP_Q_ZERO, next_zero_point); // Zero-point adjustment
            if(doActivation) {
                Xil_Out32(MLP_CTRLB, MLP_CTRLB_RELU);
            } else {
                Xil_Out32(MLP_CTRLB, 0);
            }

            for(int m = 0; m < numOfMaps / 4; m++) {
                // Transfer input data and weights to BRAM
                // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) & ~(MLP_CTRLB_SWAP_FILTERS));

                memcpy_dma(MLP_FILTER0, getWeightData().getRaw<int8_t>() + (m * numIfMaps), numIfMaps * numOfMaps);
                memcpy_dma(MLP_FILTER1, getWeightData().getRaw<int8_t>() + ((m + 1) * numIfMaps), numIfMaps * numOfMaps);
                memcpy_dma(MLP_FILTER2, getWeightData().getRaw<int8_t>() + ((m + 2) * numIfMaps), numIfMaps * numOfMaps);
                memcpy_dma(MLP_FILTER3, getWeightData().getRaw<int8_t>() + ((m + 3) * numIfMaps), numIfMaps * numOfMaps);

                // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) | (MLP_CTRLB_SWAP_FILTERS)); // swap the values we just wrote into use

                Xil_Out32(MLP_MAC0_BIAS, getBiasData().get<int32_t>(m));
                Xil_Out32(MLP_MAC1_BIAS, getBiasData().get<int32_t>(m + 1));
                Xil_Out32(MLP_MAC2_BIAS, getBiasData().get<int32_t>(m + 2));
                Xil_Out32(MLP_MAC3_BIAS, getBiasData().get<int32_t>(m + 3));

                // trigger HW accelerator
                Xil_Out32(MLP_CTRLA, ~(MLP_CTRLA_CONV_IDLE));

                // Wait for computation to complete
                while(!(Xil_In32(MLP_CTRLA) & MLP_CTRLA_CONV_IDLE));

                // Transfer output data from BRAM to DDR
                memcpy_dma(getOutputData().getRaw<int8_t>() + (4 * m), MLP_OUTPUTS, 4);
            }
            #else
            // iterate for each output feature map (channel)
            for(int m = 0; m < numOfMaps; m++) {
                // iterate for each input feature map
                int32_t result = 0;
                int32_t weightSum = 0;
                for(int c = 0; c < numIfMaps; c++) {
                    int32_t dataIndex = (n * numIfMaps) + c;
                    int32_t weightIndex = (n * numIfMaps * numOfMaps) + (m * numIfMaps) + c;

                    if(dataIndex > numIfMaps) {
                        printf("!!! Exceeded input dimensions !!!\n");
                    }

                    if(weightIndex > numIfMaps * numOfMaps) {
                        printf("!!! Exceeded weight dimensions !!!\n");
                    }

                    int32_t i = dataIn.get<int8_t>(dataIndex);
                    int32_t f = weightData.get<int8_t>(weightIndex);

                    result += i * f;
                    weightSum += f;
                }

                // apply bias
                int64_t biased = result + biasData.get<int32_t>(m);
                // multiply to dequantize this layer and requantize for next
                int64_t scaled = biased * finalScale;
                int64_t shifted = (scaled >> 32);
                int64_t relued = shifted;
                if(doActivation) {
                    relued = (shifted > 0) ? shifted : 0;
                }
                int64_t zeroed = relued + next_zero_point;

                // saturate
                if(zeroed > 127) {
                    zeroed = 127;
                } else if(zeroed < -128) {
                    zeroed = -128;
                }

                uint32_t outIndex = (n * numOfMaps) + m;

                if(outIndex >= getOutputData().getParams().flat_count() || outIndex < 0) {
                    printf("!!! Exceeded output dimensions !!!\n");
                }

                getOutputData().get<int8_t>(outIndex) = static_cast<int8_t>(zeroed);
            }
            #endif
        }
    }

}