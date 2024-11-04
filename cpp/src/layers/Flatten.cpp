#include "Flatten.h"

namespace ML {

    void FlattenLayer::computeNaive(const LayerData& dataIn) const {
        int dataInLen = 1;
        for(unsigned long i = 0; i < dataIn.getParams().dims.size(); i++) {
            dataInLen *= dataIn.getParams().dims.at(i);
        }

        for(int n = 0; n < dataInLen; n++) {
            getOutputData().get<fp32>(n) = dataIn.get<fp32>(n);
        }
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