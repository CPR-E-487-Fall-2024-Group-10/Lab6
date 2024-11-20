#pragma once

#include "../Types.h"
#include "../Utils.h"
#include "Layer.h"

namespace ML {
class ConvolutionalLayer : public Layer {
   public:
    ConvolutionalLayer(const LayerParams inParams, const LayerParams outParams, const LayerParams weightParams, const LayerParams biasParams, const LayerParams weightParamsQuantized, int32_t input_scale, int32_t next_input_scale, int8_t next_zero_point)
        : Layer(inParams, outParams, LayerType::CONVOLUTIONAL),
          weightParam(weightParams),
          weightData(weightParams),
          biasParam(biasParams),
          biasData(biasParams),
          weightParamsQuantized(weightParamsQuantized),
          weightDataQuantized(weightParamsQuantized),
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

    // Allocate all resources needed for the layer & Load all of the required data for the layer
    virtual void allocLayer() override {
        Layer::allocLayer();
        weightData.loadData();
        biasData.loadData();

        int kernelHeight = getWeightParams().dims.at(1);
        int kernelWidth = getWeightParams().dims.at(0);
        int kernelDepth = getWeightParams().dims.at(2);
        int numKernels = getWeightParams().dims.at(3);

        // quantization code
        float quantNumerator = 127.0f; // numerator for quantization calculations

        float weight_max_abs = getWeightData().get<fp32>(0);
        float weight_max = 0.0f;
        float weight_min = 1.0f;
        for(int i = 0; i < kernelWidth * kernelHeight * kernelDepth * numKernels; i++) {
            if(fabs(getWeightData().get<fp32>(i)) > fabs(weight_max_abs)) {
                weight_max_abs = fabs(getWeightData().get<fp32>(i));
            }

            if(getWeightData().get<fp32>(i) > weight_max) {
                weight_max = getWeightData().get<fp32>(i);
            }

            if(getWeightData().get<fp32>(i) < weight_min) {
                weight_min = getWeightData().get<fp32>(i);
            }
        }

        weight_scale = (int32_t) (quantNumerator / fabs(weight_max_abs));

        // quantize weights
        weightDataQuantized.allocData();
        float maxWeight = 0.0f;
        for(int i = 0; i < kernelWidth * kernelHeight * kernelDepth * numKernels; i++) {
            weightDataQuantized.get<int8_t>(i) = static_cast<int8_t>(round(weightData.get<fp32>(i)) * weight_scale);
            if(weightData.get<fp32>(i) > maxWeight) {
                maxWeight = weightData.get<fp32>(i);
            }
        }
    }

    // Fre all resources allocated for the layer
    virtual void freeLayer() override {
        Layer::freeLayer();
        weightData.freeData();
        biasData.freeData();
        weightDataQuantized.freeData();
    }

    // Virtual functions
    virtual void computeNaive(const LayerData& dataIn) const override;
    virtual void computeThreaded(const LayerData& dataIn) const override;
    virtual void computeTiled(const LayerData& dataIn) const override;
    virtual void computeSIMD(const LayerData& dataIn) const override;
    virtual void computeAccelerated(const LayerData& dataIn, const QuantType quantType) const override;

   private:
    LayerParams weightParam;
    LayerData weightData;

    LayerParams biasParam;
    LayerData biasData;

    LayerParams weightParamsQuantized;
    LayerData weightDataQuantized;

    int32_t weight_scale;

    int32_t input_scale;
    int32_t next_input_scale;
    int8_t next_zero_point;
};

}  // namespace ML