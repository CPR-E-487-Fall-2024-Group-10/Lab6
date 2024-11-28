#include "Flatten.h"

namespace ML {

    void FlattenLayer::computeNaive(const LayerData& dataIn) const {
        int dataInLen = 1;
        for(unsigned long i = 0; i < dataIn.getParams().dims.size(); i++) {
            dataInLen *= dataIn.getParams().dims.at(i);
        }

        for(int n = 0; n < dataInLen; n++) {
            getOutputData().get<int8_t>(n) = dataIn.get<int8_t>(n);
        }

        // int numChannels = dataIn.getParams().dims.at(2);
        // int height = dataIn.getParams().dims.at(0);
        // int width = dataIn.getParams().dims.at(1);

        // int flatIndex = 0;
        // for(int c = 0; c < numChannels; c++) {
        //     for(int h = 0; h < height; h++) {
        //         for(int w = 0; w < width; w++) {
        //             getOutputData().get<int8_t>(flatIndex) = dataIn.get<int8_t>((c * height * width) + (h * width) + w);
        //             flatIndex++;
        //         }
        //     }
        // }
    }

    void FlattenLayer::computeThreaded(const LayerData& dataIn) const {
        // TODO
    }

    void FlattenLayer::computeTiled(const LayerData& dataIn) const {
        // TODO
    }

    void FlattenLayer::computeSIMD(const LayerData& dataIn) const {
        // TODO
    }

    void FlattenLayer::computeAccelerated(const LayerData& dataIn, const QuantType quantType) const {
        computeNaive(dataIn);
    }

}