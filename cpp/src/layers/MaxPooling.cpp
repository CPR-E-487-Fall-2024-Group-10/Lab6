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
                    float max = 0.0f;
                    for(int y = 0; y < vertPixelsPerPool; y++) {
                        for(int x = 0; x < horizPixelsPerPool; x++) {
                            // float data = dataIn.get<fp32>((m * outputHeight * vertPixelsPerPool * outputWidth * horizPixelsPerPool) + (i * vertPixelsPerPool * outputWidth * horizPixelsPerPool) + (y * outputWidth * horizPixelsPerPool) + (j * horizPixelsPerPool) + x);
                            float data = dataIn.get<fp32>((i * vertPixelsPerPool * outputWidth * horizPixelsPerPool * numChannels) + (y * outputWidth * horizPixelsPerPool * numChannels) + (j * horizPixelsPerPool * numChannels) + (x * numChannels) + m);
                            if(data > max) max = data;
                        }
                    }
                    getOutputData().get<fp32>((i * outputWidth * numChannels) + (j * numChannels) + m) = max;
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