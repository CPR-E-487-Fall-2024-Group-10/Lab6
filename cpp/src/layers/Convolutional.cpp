#include "Convolutional.h"

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
// --- Begin Student Code ---

// Compute the convultion for the layer data
void ConvolutionalLayer::computeNaive(const LayerData& dataIn) const {
    // TODO: Your Code Here...
    // The following line is an example of copying a single 32-bit floating point integer from the input layer data to the output layer data
    // getOutputData().get<fp32>(0) = dataIn.get<fp32>(0);

    // // number of output feature maps
    // int numOfMaps = getOutputData().getParams().dims.at(2);
    // // output height and width
    // int outHeight = getOutputData().getParams().dims.at(1);
    // int outWidth = getOutputData().getParams().dims.at(0);
    // // number of input feature maps
    // int numIfMaps = dataIn.getParams().dims.at(2);
    // // input height and width
    // int inHeight = dataIn.getParams().dims.at(1);
    // int inWidth = dataIn.getParams().dims.at(0);

    // int kernelHeight = getWeightParams().dims.at(1);
    // int kernelWidth = getWeightParams().dims.at(0);
    // int kernelDepth = getWeightParams().dims.at(2);
    // int numKernels = getWeightParams().dims.at(3);

    // // TODO see if this can be removed or needs to be another value, I don't think we ever process more than one image as a batch
    // // iterate over batch
    // for(int n = 0; n < 1; n++) {
    //     // iterate for each pixel in the output feature map
    //     // width
    //     for(int q = 0; q < outWidth; q++) {
    //         // height
    //         for(int p = 0; p < outHeight; p++) {
    //             // iterate for each output feature map (channel)
    //             for(int m = 0; m < numOfMaps; m++) {
    //                 // iterate for each pixel in the input feature map
    //                 // width
    //                 float heightSum = 0.0f;
    //                 for(int s = 0; s < kernelWidth; s++) {
    //                     // height
    //                     float widthSum = 0.0f;
    //                     for(int r = 0; r < kernelHeight; r++) {
    //                         // iterate for each input feature map (channel)
    //                         float channelSum = 0.0f;
    //                         for(int c = 0; c < kernelDepth; c++) {
    //                             channelSum += dataIn.get<fp32>((n * numIfMaps * inHeight * inWidth) + ((q + s) * inHeight * numIfMaps) + ((p + r) * numIfMaps) + c)
    //                                             * getWeightData().get<fp32>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m);
    //                         }

    //                         widthSum += channelSum;
    //                     }

    //                     heightSum += widthSum;
    //                 }

    //                 getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m) = relu(heightSum + getBiasData().get<fp32>(m));
    //             }
    //         }
    //     }
    // }
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

    // find the scale to dequantize this layer and quantize for next
    // this is kind of long-winded, but wanted to be sure bits weren't going to be lopped off unintentionally
    int64_t finalScale = next_input_scale;
    finalScale <<= 32;
    finalScale /= input_scale;
    finalScale /= weight_scale;

    // we've now quantized everything we need to, start doing math
    // iterate over batch
    for(int n = 0; n < 1; n++) {

        // now doing channel as most significant index
        #ifdef ZEDBOARD
        // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) & ~(MLP_CTRLB_SWAP_ACTIVATIONS));
        memcpy_dma(MLP_INPUTS, dataIn.getRaw<int8_t>(), inWidth * inHeight * numIfMaps);
        // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) | (MLP_CTRLB_SWAP_ACTIVATIONS));

        int diff_fw = 1 - kernelWidth + inWidth;
        int diff_fh = diff_fw - (inWidth * kernelHeight) + (inWidth * inHeight);
        int diff_fc = diff_fh - (inWidth * inHeight * kernelDepth) + 1;
        int diff_ow = diff_fc + (kernelWidth - 1);
        // int diff_fh = ((inHeight * inWidth) - (inWidth * (kernelHeight - 1))) - (kernelWidth - 1);
        // int diff_fc = ((-inHeight * inWidth * (numIfMaps - 1)) - (inWidth * (kernelHeight - 1))) - (kernelWidth - 2);
        // int diff_ow = ((-inHeight * inWidth * (numIfMaps - 1)) - (inWidth * (kernelHeight - 1))) + 1;

        // Configure HW accelerator (no idea if this is correct)
        Xil_Out32(MLP_FILTER_W, kernelWidth);
        Xil_Out32(MLP_FILTER_H, kernelHeight);
        Xil_Out32(MLP_FILTER_C, kernelDepth);
        Xil_Out32(MLP_OUTPUT_W, outWidth);
        Xil_Out32(MLP_OUTPUT_H, outHeight);
        Xil_Out32(MLP_INPUT_END_DIFF_FW, diff_fw);
        Xil_Out32(MLP_INPUT_END_DIFF_FH, diff_fh);
        Xil_Out32(MLP_INPUT_END_DIFF_FC, diff_fc);
        Xil_Out32(MLP_INPUT_END_DIFF_OW, diff_ow);
        Xil_Out32(MLP_OUTPUT_ELEMENTS_PER_CHANNEL, outHeight * outWidth);
        Xil_Out32(MLP_OUTPUT_INITIAL_OFFSET, 0); // TODO this will change once we are keeping data in accelerator
        Xil_Out32(MLP_Q_SCALE, finalScale); // Quantization scaling
        Xil_Out32(MLP_Q_ZERO, next_zero_point); // Zero-point adjustment
        Xil_Out32(MLP_CTRLB, MLP_CTRLB_RELU);

        for(int m = 0; m < numOfMaps / 4; m++) {
            // Transfer input data and weights to BRAM
            // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) & ~(MLP_CTRLB_SWAP_FILTERS));
            
            memcpy_dma(MLP_FILTER0, getWeightData().getRaw<int8_t>() + (m * kernelWidth + kernelHeight * kernelDepth), kernelWidth * kernelHeight * kernelDepth);
            memcpy_dma(MLP_FILTER1, getWeightData().getRaw<int8_t>() + ((m + 1) * kernelWidth + kernelHeight * kernelDepth), kernelWidth * kernelHeight * kernelDepth);
            memcpy_dma(MLP_FILTER2, getWeightData().getRaw<int8_t>() + ((m + 2) * kernelWidth + kernelHeight * kernelDepth), kernelWidth * kernelHeight * kernelDepth);
            memcpy_dma(MLP_FILTER3, getWeightData().getRaw<int8_t>() + ((m + 3) * kernelWidth + kernelHeight * kernelDepth), kernelWidth * kernelHeight * kernelDepth);

            // Xil_Out32(MLP_CTRLB, Xil_In32(MLP_CTRLB) | (MLP_CTRLB_SWAP_FILTERS)); // swap the values we just wrote into use

            Xil_Out32(MLP_MAC0_BIAS, getBiasData().get<int32_t>(m));
            Xil_Out32(MLP_MAC1_BIAS, getBiasData().get<int32_t>(m + 1));
            Xil_Out32(MLP_MAC2_BIAS, getBiasData().get<int32_t>(m + 2));
            Xil_Out32(MLP_MAC3_BIAS, getBiasData().get<int32_t>(m + 3));

            // trigger HW accelerator
            Xil_Out32(MLP_CTRLA, ~(MLP_CTRLA_CONV_IDLE));

            int cnt = 0;

            // Wait for computation to complete
            while(!(Xil_In32(MLP_CTRLA) & MLP_CTRLA_CONV_IDLE)) cnt++;

            printf("Took %d iterations for conv idle to happen\n", cnt);

            // Transfer output data from BRAM to DDR
            memcpy_dma(getOutputData().getRaw<int8_t>() + (4 * m * outHeight * outWidth), MLP_OUTPUTS, 4 * outWidth * outHeight);
        }
        #else
        for(int m = 0; m < numOfMaps; m++) {
            for(int q = 0; q < outWidth; q++) {
                for(int p = 0; p < outHeight; p++) {
                    // iterate for each pixel in the input feature map
                    int32_t channelSum = 0;
                    for(int c = 0; c < kernelDepth; c++) {
                        int32_t widthSum = 0;
                        for(int s = 0; s < kernelWidth; s++) {
                            int32_t heightSum = 0;
                            for(int r = 0; r < kernelHeight; r++) {
                                uint32_t dataIndex = (n * numIfMaps * inHeight * inWidth) + (c * inHeight * inWidth) + ((p + r) * inWidth) + (q + s);
                                uint32_t weightIndex = (n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (m * kernelDepth * kernelHeight * kernelWidth) + (c * kernelHeight * kernelWidth) + (r * kernelWidth) + s;

                                if(dataIndex >= dataIn.getParams().flat_count() || dataIndex < 0) {
                                    printf("!!! Exceeded input dimensions !!!\n");
                                }

                                if(weightIndex >= weightData.getParams().flat_count() || weightIndex < 0) {
                                    printf("!!! Exceeded weight dimensions !!!\n");
                                }

                                int16_t data = ((int16_t) dataIn.get<int8_t>(dataIndex));
                                int16_t weight = ((int16_t) weightData.get<int8_t>(weightIndex));

                                int32_t product = data * weight;

                                heightSum += product;
                            }

                            widthSum += heightSum;
                        }

                        channelSum += widthSum;
                    }

                    // apply bias
                    int64_t biased = channelSum + biasData.get<int32_t>(m);
                    // multiply to dequantize this layer and requantize for next
                    int64_t scaled = biased * finalScale;
                    int64_t shifted = (scaled >> 32);
                    int64_t relued = (shifted > 0) ? shifted : 0;
                    int64_t zeroed = relued + next_zero_point;

                    // saturate
                    if(zeroed > 127) {
                        zeroed = 127;
                    } else if(zeroed < -128) {
                        zeroed = -128;
                    }

                    uint32_t outIndex = (n * numOfMaps * outHeight * outWidth) + (m * outHeight * outWidth) + (p * outWidth) + q;

                    if(outIndex >= getOutputData().getParams().flat_count() || outIndex < 0) {
                        printf("!!! Exceeded output dimensions !!!\n");
                    }

                    getOutputData().get<int8_t>(outIndex) = static_cast<int8_t>(zeroed);

                }
            }
        }
        #endif
    }
}

}  // namespace ML

