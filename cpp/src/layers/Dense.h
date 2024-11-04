#pragma once

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

namespace ML {

    class DenseLayer : public Layer {

        public:
            DenseLayer(const LayerParams inParams, const LayerParams outParams, const LayerParams weightParams, const LayerParams biasParams, bool doActivation)
                : Layer(inParams, outParams, LayerType::DENSE),
                weightParam(weightParams),
                weightData(weightParams),
                biasParam(biasParams),
                biasData(biasParams),
                doActivation(doActivation)
                {}

            // Getters
            const LayerParams& getWeightParams() const { return weightParam; }
            const LayerParams& getBiasParams() const { return biasParam; }
            const LayerData& getWeightData() const { return weightData; }
            const LayerData& getBiasData() const { return biasData; }

            // Virtual functions
            virtual void computeNaive(const LayerData& dataIn) const override;
            virtual void computeThreaded(const LayerData& dataIn) const override;
            virtual void computeTiled(const LayerData& dataIn) const override;
            virtual void computeSIMD(const LayerData& dataIn) const override;
            virtual void computeAccelerated(const LayerData& dataIn, const QuantType quantType) const override;

            // Allocate all resources needed for the layer & Load all of the required data for the layer
            virtual void allocLayer() override {
                Layer::allocLayer();
                weightData.loadData();
                biasData.loadData();
            }

            // Fre all resources allocated for the layer
            virtual void freeLayer() override {
                Layer::freeLayer();
                weightData.freeData();
                biasData.freeData();
            }

        private:
            LayerParams weightParam;
            LayerData weightData;

            LayerParams biasParam;
            LayerData biasData;
            
            bool doActivation;

    };

}