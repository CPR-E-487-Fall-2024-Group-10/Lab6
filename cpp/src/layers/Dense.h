#pragma once

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

namespace ML {

    class DenseLayer : public Layer {

        public:
            DenseLayer(const LayerParams inParams, const LayerParams outParams, const LayerParams weightParams, const LayerParams biasParams, const LayerParams weightParamsQuantized, bool doActivation, int32_t input_scale, int32_t next_input_scale, int8_t next_zero_point)
                : Layer(inParams, outParams, LayerType::DENSE),
                weightParam(weightParams),
                weightData(weightParams),
                biasParam(biasParams),
                biasData(biasParams),
                weightParamsQuantized(weightParamsQuantized),
                weightDataQuantized(weightParamsQuantized),
                doActivation(doActivation),
                input_scale(input_scale),
                next_input_scale(next_input_scale),
                next_zero_point(next_zero_point)
                {}

            // Getters
            const LayerParams& getWeightParams() const { return weightParam; }
            const LayerParams& getBiasParams() const { return biasParam; }
            const LayerData& getWeightData() const { return weightData; }
            const LayerData& getBiasData() const { return biasData; }
            const LayerData& getWeightDataQuantized() const { return weightDataQuantized; }

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

                // number of output feature maps
                int numOfMaps = getOutputData().getParams().dims.at(0);
                // number of input feature maps
                int numIfMaps = weightParam.dims.at(0);

                float quantNumerator = 127.0f;

                float weight_max = getWeightData().get<fp32>(0);
                for(int i = 0; i < numIfMaps * numOfMaps; i++) {
                    if(fabs(getWeightData().get<fp32>(i)) > fabs(weight_max)) {
                        weight_max = fabs(getWeightData().get<fp32>(i));
                    }
                }

                weight_scale = (int32_t) (quantNumerator / fabs(weight_max));

                // quantize weights
                weightDataQuantized.allocData();
                for(int i = 0; i < numIfMaps * numOfMaps; i++) {
                    weightDataQuantized.get<int8_t>(i) = static_cast<int8_t>(round(getWeightData().get<fp32>(i)) * weight_scale);
                }
            }

            // Fre all resources allocated for the layer
            virtual void freeLayer() override {
                Layer::freeLayer();
                weightData.freeData();
                biasData.freeData();
                weightDataQuantized.freeData();
            }

        private:
            LayerParams weightParam;
            LayerData weightData;

            LayerParams biasParam;
            LayerData biasData;

            LayerParams weightParamsQuantized;
            LayerData weightDataQuantized;
            
            bool doActivation;
            int32_t weight_scale;

            int32_t input_scale;
            int32_t next_input_scale;
            int8_t next_zero_point;
    };

}