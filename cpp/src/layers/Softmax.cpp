#include "Softmax.h"

#include <math.h>

namespace ML {

    void SoftmaxLayer::computeNaive(const LayerData& dataIn) const {
        LayerParams dequantizedParams(sizeof(fp32), dataIn.getParams().dims);
        LayerData dataInDequantized(dequantizedParams);
        dataInDequantized.allocData();

        for(unsigned long i = 0; i < dataInDequantized.getParams().flat_count(); i++) {
            dataInDequantized.get<fp32>(i) = (float) ((dataIn.get<int8_t>(i) * scale) + zero_point);
        }

        int inputLen = dataIn.getParams().dims.at(0);

        float sum = 0.0f;

        for(int n = 0; n < inputLen; n++) {
            sum += exp(dataIn.get<fp32>(n));
        }

        for(int n = 0; n < inputLen; n++) {
            getOutputData().get<fp32>(n) = exp(dataIn.get<fp32>(n)) / sum;
        }

        dataInDequantized.freeData();
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