#include "Convolutional.h"

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
// --- Begin Student Code ---

// Compute the convultion for the layer data
void ConvolutionalLayer::computeNaive(const LayerData& dataIn) const {
    // TODO: Your Code Here...
    // The following line is an example of copying a single 32-bit floating point integer from the input layer data to the output layer data
    getOutputData().get<fp32>(0) = dataIn.get<fp32>(0);

    // number of output feature maps
    int numOfMaps = getOutputData().getParams().dims.at(2);
    // output height and width
    int outHeight = getOutputData().getParams().dims.at(1);
    int outWidth = getOutputData().getParams().dims.at(0);
    // number of input feature maps
    int numIfMaps = dataIn.getParams().dims.at(2);
    // input height and width
    int inHeight = dataIn.getParams().dims.at(1);
    int inWidth = dataIn.getParams().dims.at(0);

    int kernelHeight = getWeightParams().dims.at(1);
    int kernelWidth = getWeightParams().dims.at(0);
    int kernelDepth = getWeightParams().dims.at(2);
    int numKernels = getWeightParams().dims.at(3);

    // TODO see if this can be removed or needs to be another value, I don't think we ever process more than one image as a batch
    // iterate over batch
    for(int n = 0; n < 1; n++) {
        // iterate for each pixel in the output feature map
        // width
        for(int q = 0; q < outWidth; q++) {
            // height
            for(int p = 0; p < outHeight; p++) {
                // iterate for each output feature map (channel)
                for(int m = 0; m < numOfMaps; m++) {
                    // iterate for each pixel in the input feature map
                    // width
                    float heightSum = 0.0f;
                    for(int s = 0; s < kernelWidth; s++) {
                        // height
                        float widthSum = 0.0f;
                        for(int r = 0; r < kernelHeight; r++) {
                            // iterate for each input feature map (channel)
                            float channelSum = 0.0f;
                            for(int c = 0; c < kernelDepth; c++) {
                                channelSum += dataIn.get<fp32>((n * numIfMaps * inHeight * inWidth) + ((q + s) * inHeight * numIfMaps) + ((p + r) * numIfMaps) + c)
                                                * getWeightData().get<fp32>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m);
                            }

                            widthSum += channelSum;
                        }

                        heightSum += widthSum;
                    }

                    getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m) = relu(heightSum + getBiasData().get<fp32>(m));
                }
            }
        }
    }
}

// Compute the convolution using threads
void ConvolutionalLayer::computeThreaded(const LayerData& dataIn) const {
    // TODO: Your Code Here...
}

// Compute the convolution using a tiled approach
void ConvolutionalLayer::computeTiled(const LayerData& dataIn) const {
    // TODO: Your Code Here...
}

// Compute the convolution using SIMD
void ConvolutionalLayer::computeSIMD(const LayerData& dataIn) const {
    // TODO: Your Code Here...
}

void ConvolutionalLayer::computeAccelerated(const LayerData& dataIn, const QuantType quantType) const {
    // number of output feature maps
    int numOfMaps = getOutputData().getParams().dims.at(2);
    // output height and width
    int outHeight = getOutputData().getParams().dims.at(1);
    int outWidth = getOutputData().getParams().dims.at(0);
    // number of input feature maps
    int numIfMaps = dataIn.getParams().dims.at(2);
    // input height and width
    int inHeight = dataIn.getParams().dims.at(1);
    int inWidth = dataIn.getParams().dims.at(0);

    int kernelHeight = getWeightParams().dims.at(1);
    int kernelWidth = getWeightParams().dims.at(0);
    int kernelDepth = getWeightParams().dims.at(2);
    int numKernels = getWeightParams().dims.at(3);

    // quantization code
    float input_max_diff = 0.0f;
    float input_avg = 0.0f;
    float input_min = 1.0f;
    float input_max = 0.0f;
    for(int i = 0; i < numIfMaps * inHeight * inWidth; i++) {
        input_avg += dataIn.get<fp32>(i);

        if(dataIn.get<fp32>(i) > input_max) {
            input_max = dataIn.get<fp32>(i);
        }

        if(dataIn.get<fp32>(i) < input_min) {
            input_min = dataIn.get<fp32>(i);
        }
    }

    input_avg /= numIfMaps * inHeight * inWidth;

    for(int i = 0; i < numIfMaps * inHeight * inWidth; i++) {
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

    float weight_max_abs = getWeightData().get<fp32>(0);
    float weight_max = 0.0f;
    float weight_min = 1.0f;
    for(int i = 0; i < kernelWidth * kernelHeight * kernelDepth * numKernels; i++) {
        if(fabs(getWeightData().get<fp32>(i)) > fabs(weight_max_abs)) {
            weight_max_abs = fabs(getWeightData().get<fp32>(i));
        }

        if(getWeightData().get<fp32>(i) > weight_max) {
            weight_max = getWeightData().get<fp32>(i);
        }

        if(getWeightData().get<fp32>(i) < weight_min) {
            weight_min = getWeightData().get<fp32>(i);
        }
    }

    float weight_scale = quantNumerator / fabs(weight_max_abs);
    
    int8_t zero_point = static_cast<int8_t>(-round(input_avg * input_scale));
    
    // quantize input
    LayerParams quantizedInputParams(1, dataIn.getParams().dims);
    LayerData quantizedInputData(quantizedInputParams);
    quantizedInputData.allocData();
    for(int i = 0; i < numIfMaps * inHeight * inWidth; i++) {
        quantizedInputData.get<int8_t>(i) = static_cast<int8_t>(static_cast<int16_t>(round(dataIn.get<fp32>(i) * input_scale)) + zero_point);
    }    

    // quantize weights
    LayerParams quantizedWeightParams(1, weightParam.dims);
    LayerData quantizedWeightData(quantizedWeightParams);
    quantizedWeightData.allocData();
    float maxWeight = 0.0f;
    for(int i = 0; i < kernelWidth * kernelHeight * kernelDepth * numKernels; i++) {
        quantizedWeightData.get<int8_t>(i) = static_cast<int8_t>(round(weightData.get<fp32>(i) * weight_scale));
        if(weightData.get<fp32>(i) > maxWeight) {
            maxWeight = weightData.get<fp32>(i);
        }
    }

    // quantize biases
    float bias_scale = weight_scale * input_scale;

    LayerParams quantizedBiasParams(sizeof(int32_t), biasParam.dims);
    LayerData quantizedBiasData(quantizedBiasParams);
    quantizedBiasData.allocData();
    for(unsigned long i = 0; i < getBiasData().getParams().dims.at(0); i++) {
        quantizedBiasData.get<int32_t>(i) = static_cast<int32_t>(round(getBiasData().get<fp32>(i) * bias_scale));
    }

    uint32_t scale_inverse = ((double) ((long) 1 << 32)) / (((double) input_scale) * ((double) weight_scale));
    printf("%u\n", scale_inverse);

    // we've now quantized everything we need to, start doing math
    // iterate over batch
    for(int n = 0; n < 1; n++) {
        // iterate for each pixel in the output feature map
        // width
        for(int q = 0; q < outWidth; q++) {
            // height
            for(int p = 0; p < outHeight; p++) {
                // iterate for each output feature map (channel)
                for(int m = 0; m < numOfMaps; m++) {
                    #ifdef ZEDBOARD
                    int32_t weightSum = 0;

                    int32_t writeData = 0;
                    uint8_t numPacked = 0;
                    for(int s = 0; s < kernelWidth; s++) {
                        for(int r = 0; r < kernelHeight; r++) {
                            for(int c = 0; c < kernelDepth; c++) {
                                writeData <<= shiftAmt;
                                writeData |= quantizedInputData.get<int8_t>((n * numIfMaps * inHeight * inWidth) + ((q + s) * inHeight * numIfMaps) + ((p + r) * numIfMaps) + c) & andMask;
                                writeData <<= shiftAmt;
                                writeData |= quantizedWeightData.get<int8_t>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m) & andMask;

                                numPacked++;

                                if(numPacked == packAmt) {
                                    writeData |= (quantSelect << 16);

                                    Xil_Out32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_TDFD_OFFSET, writeData);

                                    numPacked = 0;
                                    writeData = 0;
                                }

                                weightSum += quantizedWeightData.get<int8_t>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m);
                            }
                        }
                    }

                    // send any extra
                    if(numPacked > 0) {
                        writeData |= (quantSelect << 16);

                        Xil_Out32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_TDFD_OFFSET, writeData);
                    }

                    // set length of transmit
                    int32_t txLen = ((kernelWidth * kernelHeight * kernelDepth) / packAmt) * 4; // length is number of elements times 4 (since it is in bytes) divided by number per 32 bits
                    if(numPacked != 0) txLen += 4; // handle case where not evenly divisible

                    Xil_Out32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_TLF_OFFSET, txLen);

                    while (Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RDFO_OFFSET) == 0);

                    uint32_t readLen = Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RLF_OFFSET);

                    int32_t result = (int32_t) Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RDFD_OFFSET);
                    readLen -= 4;

                    // shouldn't happen, MAC only ever sends a single word
                    while(readLen > 0) int32_t junk = Xil_In32(XPAR_AXI_FIFO_0_BASEADDR + XLLF_RDFD_OFFSET);

                    #else

                    // iterate for each pixel in the input feature map
                    // width
                    int32_t heightSum = 0;
                    int32_t weightSum = 0;
                    float heightSumFloat = 0.0f;
                    for(int s = 0; s < kernelWidth; s++) {
                        // height
                        int32_t widthSum = 0;
                        float widthSumFloat = 0.0f;
                        for(int r = 0; r < kernelHeight; r++) {
                            // iterate for each input feature32 map (channel)
                            int32_t channelSum = 0;
                            float channelSumFloat = 0.0f;
                            for(int c = 0; c < kernelDepth; c++) {
                                int16_t data = ((int16_t) quantizedInputData.get<int8_t>((n * numIfMaps * inHeight * inWidth) + ((q + s) * inHeight * numIfMaps) + ((p + r) * numIfMaps) + c));
                                int16_t weight = ((int16_t) quantizedWeightData.get<int8_t>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m));
                                int32_t product = data * weight;
                                channelSum += product;

                                weightSum += quantizedWeightData.get<int8_t>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m);

                                channelSumFloat += dataIn.get<fp32>((n * numIfMaps * inHeight * inWidth) + ((q + s) * inHeight * numIfMaps) + ((p + r) * numIfMaps) + c)
                                                * getWeightData().get<fp32>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m);
                            }

                            widthSum += channelSum;
                            widthSumFloat += channelSumFloat;
                        } 

                        heightSum += widthSum;
                        heightSumFloat += widthSumFloat;
                    }

                    int32_t result = heightSum;

                    #endif

                    // float activation = relu(static_cast<float>((result + quantizedBiasData.get<int32_t>(m)) - (zero_point * weightSum)) / (input_scale * weight_scale));

                    // getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m) = activation;

                    getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m) = (float) (((result + quantizedBiasData.get<int32_t>(m) - (zero_point * weightSum)) * ((uint64_t) scale_inverse))) / ((float) ((long) 1 << 32));
                    // printf("%f\n", getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m));
                }
            }
        }
    }
}

}  // namespace ML

