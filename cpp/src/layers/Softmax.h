#pragma once

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

namespace ML {

    class SoftmaxLayer : public Layer {

        public:
            SoftmaxLayer(const LayerParams inParams, const LayerParams outParams)
                : Layer(inParams, outParams, LayerType::SOFTMAX) {}

            // virtual functions
            virtual void computeNaive(const LayerData& dataIn) const override;
            virtual void computeThreaded(const LayerData& dataIn) const override;
            virtual void computeTiled(const LayerData& dataIn) const override;
            virtual void computeSIMD(const LayerData& dataIn) const override;
            virtual void computeAccelerated(const LayerData& dataIn, const QuantType quantType) const override;

    };

}