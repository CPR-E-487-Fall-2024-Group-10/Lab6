#include "Softmax.h"

#include <math.h>

namespace ML {

    void SoftmaxLayer::computeNaive(const LayerData& dataIn) const {
        int inputLen = dataIn.getParams().dims.at(0);

        float sum = 0.0f;

        for(int n = 0; n < inputLen; n++) {
            sum += exp(dataIn.get<fp32>(n));
        }

        for(int n = 0; n < inputLen; n++) {
            getOutputData().get<fp32>(n) = exp(dataIn.get<fp32>(n)) / sum;
        }
    }

    void SoftmaxLayer::computeThreaded(const LayerData& dataIn) const {
        // TODO
    }

    void SoftmaxLayer::computeTiled(const LayerData& dataIn) const {
        // TODO
    }

    void SoftmaxLayer::computeSIMD(const LayerData& dataIn) const {
        // TODO
    }

    void SoftmaxLayer::computeAccelerated(const LayerData& dataIn, const QuantType quantType) const {
        computeNaive(dataIn);
    }

}