#include "MaxPooling.h"

#include <iostream>

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

namespace ML {

    void MaxPoolingLayer::computeNaive(const LayerData& dataIn) const {
        int numChannels = getOutputParams().dims.at(2);
        int outputHeight = getOutputParams().dims.at(1);
        int outputWidth = getOutputParams().dims.at(0);

        int vertPixelsPerPool = getInputParams().dims.at(1) / outputHeight;
        int horizPixelsPerPool = getInputParams().dims.at(0) / outputWidth;

        for(int m = 0; m < numChannels; m++) {
            for(int i = 0; i < outputHeight; i++) {
                for(int j = 0; j < outputWidth; j++) {
                    int8_t max = 0;
                    for(int y = 0; y < vertPixelsPerPool; y++) {
                        for(int x = 0; x < horizPixelsPerPool; x++) {
                            uint32_t dataIndex = (m * outputHeight * vertPixelsPerPool * outputWidth * horizPixelsPerPool) + (i * vertPixelsPerPool * outputWidth * horizPixelsPerPool) + (y * outputWidth * horizPixelsPerPool) + (j * horizPixelsPerPool) + x;

                            if(dataIndex > dataIn.getParams().flat_count() || dataIndex < 0) {
                                printf("!!! Exceeded input dimensions !!!\n");
                            }

                            int8_t data = dataIn.get<int8_t>(dataIndex);
                            // int8_t data = dataIn.get<int8_t>((m * outputHeight * vertPixelsPerPool * outputWidth * horizPixelsPerPool) + (i * vertPixelsPerPool * outputWidth * horizPixelsPerPool) + (y * outputWidth * horizPixelsPerPool) + (j * horizPixelsPerPool) + x);
                            if(data > max) max = data;
                        }
                    }

                    uint32_t outIndex = (m * outputHeight * outputWidth) + (i * outputWidth) + j;

                    if(outIndex >= getOutputData().getParams().flat_count() || outIndex < 0) {
                        printf("!!! Exceeded output dimensions !!!\n");
                    }

                    getOutputData().get<int8_t>(outIndex) = max;

                    // getOutputData().get<int8_t>((m * outputHeight * outputWidth) + (i * outputWidth) + j) = max;
                }
            }
        }
    }

    void MaxPoolingLayer::computeThreaded(const LayerData& dataIn) const {
        // TODO
    }

    void MaxPoolingLayer::computeTiled(const LayerData& dataIn) const {
        // TODO
    }

    void MaxPoolingLayer::computeSIMD(const LayerData& dataIn) const {
        // TODO
    }

    void MaxPoolingLayer::computeAccelerated(const LayerData& dataIn, const QuantType quantType) const {
        // don't have a way to accelerate
        computeNaive(dataIn);
    }

}