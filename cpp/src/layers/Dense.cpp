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
            // iterate for each output feature map (channel)
            for(int m = 0; m < numOfMaps; m++) {
                #ifdef ZEDBOARD
                
                #else

                // iterate for each input feature map
                int32_t result = 0;
                int32_t weightSum = 0;
                for(int c = 0; c < numIfMaps; c++) {
                    int32_t dataIndex = (n * numIfMaps) + c;
                    int32_t weightIndex = (n * numIfMaps * numOfMaps) + (c * numOfMaps) + m;

                    if(dataIndex > numIfMaps) {
                        printf("!!! Exceeded input dimensions !!!\n");
                    }

                    if(weightIndex > numIfMaps * numOfMaps) {
                        printf("!!! Exceeded weight dimensions !!!\n");
                    }

                    int32_t i = dataIn.get<int8_t>((n * numIfMaps) + c);
                    int32_t f = weightData.get<int8_t>((n * numIfMaps * numOfMaps) + (c * numOfMaps) + m); // TODO investigate

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
                    relued = (scaled > 0) ? scaled : 0;
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

                // getOutputData().get<int8_t>((n * numOfMaps) + m) = static_cast<int8_t>(zeroed);

                #endif
            }
        }    
    }

}