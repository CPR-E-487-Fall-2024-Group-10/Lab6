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

    // find the scale to dequantize this layer and quantize for next
    // this is kind of long-winded, but wanted to be sure bits weren't going to be lopped off unintentionally
    int64_t finalScale = next_input_scale;
    finalScale <<= 32;
    finalScale /= input_scale;
    finalScale /= weight_scale;

    printf("%ld\n", finalScale); // DEBUG to assert that it's not zero or some other bad value

    // we've now quantized everything we need to, start doing math
    // iterate over batch
    for(int n = 0; n < 1; n++) {

        // now doing channel as most significant index
        for(int m = 0; m < numOfMaps; m++) {
            for(int q = 0; q < outWidth; q++) {
                for(int p = 0; p < outHeight; p++) {
                    #ifdef ZEDBOARD
                    // TODO - implement DMA transfers
                    #else

                    // iterate for each pixel in the input feature map
                    // width
                    int32_t channelSum = 0;
                    for(int c = 0; c < kernelDepth; c++) {
                        int32_t heightSum = 0;
                        for(int s = 0; s < kernelWidth; s++) {
                            int32_t widthSum = 0;
                            for(int r = 0; r < kernelHeight; r++) {
                                int16_t data = ((int16_t) dataIn.get<int8_t>((n * numIfMaps * inHeight * inWidth) + (c * inHeight * inWidth) + ((q + s) * inHeight) + (p + r)));
                                // TODO need to reorder weights as well for final hardware implementation, this should work for testing
                                int16_t weight = ((int16_t) weightDataQuantized.get<int8_t>((n * kernelDepth * kernelHeight * kernelWidth * numKernels) + (s * kernelHeight * kernelDepth * numKernels) + (r * kernelDepth * numKernels) + (c * numKernels) + m));
                                int32_t product = data * weight;

                                widthSum += product;
                            }

                            heightSum += widthSum;
                        }

                        channelSum += heightSum;
                    }

                    // apply bias
                    int64_t biased = channelSum + biasData.get<int32_t>(m);
                    // multiply to dequantize this layer and requantize for next
                    int64_t scaled = biased * finalScale;
                    int64_t zeroed = scaled + next_zero_point;

                    // saturate
                    if(zeroed > 127) {
                        zeroed = 127;
                    } else if(zeroed < -128) {
                        zeroed = -128;
                    }

                    getOutputData().get<int8_t>((n * numOfMaps * outHeight * outWidth) + (m * outHeight * outWidth) + (q * outHeight) + p) = static_cast<int8_t>(zeroed);

                    #endif

                    // float activation = relu(static_cast<float>((result + quantizedBiasData.get<int32_t>(m)) - (zero_point * weightSum)) / (input_scale * weight_scale));

                    // getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m) = activation;

                    // getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m) = (float) (((result + quantizedBiasData.get<int32_t>(m) - (zero_point * weightSum)) * ((uint64_t) scale_inverse))) / ((float) ((long) 1 << 32));
                    // printf("%f\n", getOutputData().get<fp32>((n * numOfMaps * outHeight * outWidth) + (q * outHeight * numOfMaps) + (p * numOfMaps) + m));
                }
            }
        }
    }
}

}  // namespace ML

