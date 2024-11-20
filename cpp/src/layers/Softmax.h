#pragma once

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

namespace ML {

    class SoftmaxLayer : public Layer {

        public:
            SoftmaxLayer(const LayerParams inParams, const LayerParams outParams, int32_t scale, int8_t zero_point)
                : Layer(inParams, outParams, LayerType::SOFTMAX),
                scale(scale),
                zero_point(zero_point)
                {}

            // virtual functions
            virtual void computeNaive(const LayerData& dataIn) const override;
            virtual void computeThreaded(const LayerData& dataIn) const override;
            virtual void computeTiled(const LayerData& dataIn) const override;
            virtual void computeSIMD(const LayerData& dataIn) const override;
            virtual void computeAccelerated(const LayerData& dataIn, const QuantType quantType) const override;

        private:
            int32_t scale;
            int8_t zero_point;

    };

}