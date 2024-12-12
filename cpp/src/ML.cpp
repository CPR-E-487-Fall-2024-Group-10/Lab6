#include <iostream>
#include <sstream>
#include <vector>

#include "Config.h"
#include "Model.h"
#include "Types.h"
#include "Utils.h"
#include "layers/Convolutional.h"
#include "layers/Dense.h"
#include "layers/Flatten.h"
#include "layers/Layer.h"
#include "layers/MaxPooling.h"
#include "layers/Softmax.h"

#ifdef ZEDBOARD
#include <file_transfer/file_transfer.h>
#include "MLP.h"
#include "xil_io.h"
#endif

namespace ML {

// Build our ML toy model
Model buildToyModel(const Path modelPath) {
    Model model;
    logInfo("--- Building Toy Model ---");

    // --- Conv 1: L1 ---
    // Input shape: 64x64x3
    // Output shape: 60x60x32

    // You can pick how you want to implement your layers, both are allowed:

    // LayerParams conv1_inDataParam(sizeof(fp32), {64, 64, 3});
    // LayerParams conv1_outDataParam(sizeof(fp32), {60, 60, 32});
    // LayerParams conv1_weightParam(sizeof(fp32), {5, 5, 3, 32}, modelPath / "conv1_weights.bin");
    // LayerParams conv1_biasParam(sizeof(fp32), {32}, modelPath / "conv1_biases.bin");
    // auto conv1 = new ConvolutionalLayer(conv1_inDataParam, conv1_outDataParam, conv1_weightParam, conv1_biasParam);

    // Summary of input scales and zero points for various layers
    // Scale was taken as the maximum scale from test images
    // Zero point was the closest zero point to 0 from test images
    // Conv 1
    // Input scale = 255, Zero point = -128
    // Conv 2
    // Input scale = 201, Zero point = -4
    // Conv 3
    // Input scale = 122, Zero point = -3
    // Conv 4
    // Input scale = 192, Zero point = -2
    // Conv 5
    // Input scale = 176, Zero point = -4
    // Conv 6
    // Input scale = 124, Zero point = -6
    // Dense 1
    // Input scale = 69, Zero point = -6
    // Dense 2
    // Input scale = 25, Zero point = -10

    model.addLayer<ConvolutionalLayer>(
        LayerParams{sizeof(int8_t), {64, 64, 3}},                                    // Input Data
        LayerParams{sizeof(int8_t), {60, 60, 32}},                                   // Output Data
        LayerParams{sizeof(int8_t), {5, 5, 3, 32}, modelPath / "conv1_weights.bin"}, // Weights
        LayerParams{sizeof(int32_t), {32}, modelPath / "conv1_biases.bin"},           // Bias
        419,
        255, // Input scale for this layer
        100, // Input scale for next layer
        -4   // Zero point for next layer
    );

    // --- Conv 2: L2 ---
    // Input shape: 60x60x32
    // Output shape: 56x56x32
    model.addLayer<ConvolutionalLayer>(
        LayerParams{sizeof(int8_t), {60, 60, 32}},
        LayerParams{sizeof(int8_t), {56, 56, 32}},
        LayerParams{sizeof(int8_t), {5, 5, 32, 32}, modelPath / "conv2_weights.bin"},
        LayerParams{sizeof(int32_t), {32}, modelPath / "conv2_biases.bin"},
        260,
        100,
        50,
        -3
    );

    // --- MPL 1: L3 ---
    // Input shape: 56x56x32
    // Output shape: 28x28x32
    model.addLayer<MaxPoolingLayer>(
        LayerParams{sizeof(int8_t), {56, 56, 32}},
        LayerParams{sizeof(int8_t), {28, 28, 32}}
    );

    // --- Conv 3: L4 ---
    // Input shape: 28x28x32
    // Output shape: 26x26x64
    model.addLayer<ConvolutionalLayer>(
        LayerParams{sizeof(int8_t), {28, 28, 32}},
        LayerParams{sizeof(int8_t), {26, 26, 64}},
        LayerParams{sizeof(int8_t), {3, 3, 32, 64}, modelPath / "conv3_weights.bin"},
        LayerParams{sizeof(int32_t), {64}, modelPath / "conv3_biases.bin"},
        183,
        50,
        80,
        -2
    );

    // --- Conv 4: L5 ---
    // Input shape: 26x26x64
    // Output shape: 24x24x64
    model.addLayer<ConvolutionalLayer>(
        LayerParams{sizeof(int8_t), {26, 26, 64}},
        LayerParams{sizeof(int8_t), {24, 24, 64}},
        LayerParams{sizeof(int8_t), {3, 3, 64, 64}, modelPath / "conv4_weights.bin"},
        LayerParams{sizeof(int32_t), {64}, modelPath / "conv4_biases.bin"},
        234,
        80,
        90,
        -4
    );

    // --- MPL 2: L6 ---
    // Input shape: 24x24x64
    // Output shape: 12x12x64
    model.addLayer<MaxPoolingLayer>(
        LayerParams{sizeof(int8_t), {24, 24, 64}},
        LayerParams{sizeof(int8_t), {12, 12, 64}}
    );

    // --- Conv 5: L7 ---
    // Input shape: 12x12x64
    // Output shape: 10x10x64
    model.addLayer<ConvolutionalLayer>(
        LayerParams{sizeof(int8_t), {12, 12, 64}},
        LayerParams{sizeof(int8_t), {10, 10, 64}},
        LayerParams{sizeof(int8_t), {3, 3, 64, 64}, modelPath / "conv5_weights.bin"},
        LayerParams{sizeof(int32_t), {64}, modelPath / "conv5_biases.bin"},
        236,
        90,
        80,
        -6
    );

    // --- Conv 6: L8 ---
    // Input shape: 10x10x64
    // Output shape: 8x8x128
    model.addLayer<ConvolutionalLayer>(
        LayerParams{sizeof(int8_t), {10, 10, 64}},
        LayerParams{sizeof(int8_t), {8, 8, 128}},
        LayerParams{sizeof(int8_t), {3, 3, 64, 128}, modelPath / "conv6_weights.bin"},
        LayerParams{sizeof(int32_t), {128}, modelPath / "conv6_biases.bin"},
        248,
        80,
        45,
        -6
    );

    // --- MPL 3: L9 ---
    // Input shape: 8x8x128
    // Output shape: 4x4x128
    model.addLayer<MaxPoolingLayer>(
        LayerParams{sizeof(int8_t), {8, 8, 128}},
        LayerParams{sizeof(int8_t), {4, 4, 128}}
    );

    // --- Flatten 1: L10 ---
    // Input shape: 4x4x128
    // Output shape: 2048
    model.addLayer<FlattenLayer>(
        LayerParams{sizeof(int8_t), {4, 4, 128}},
        LayerParams{sizeof(int8_t), {2048}}
    );

    // --- Dense 1: L11 ---
    // Input shape: 2048
    // Output shape: 256
    model.addLayer<DenseLayer>(
        LayerParams{sizeof(int8_t), {2048}},
        LayerParams{sizeof(int8_t), {256}},
        LayerParams{sizeof(int8_t), {2048, 256}, modelPath / "dense1_weights.bin"},
        LayerParams{sizeof(int32_t), {256}, modelPath / "dense1_biases.bin"},
        true,
        227,
        45,
        15,
        -10
    );

    // --- Dense 2: L12 ---
    // Input shape: 256
    // Output shape: 200
    model.addLayer<DenseLayer>(
        LayerParams{sizeof(int8_t), {256}},
        LayerParams{sizeof(int8_t), {200}},
        LayerParams{sizeof(int8_t), {256, 200}, modelPath / "dense2_weights.bin"},
        LayerParams{sizeof(int32_t), {200}, modelPath / "dense2_biases.bin"},
        false,
        95,
        15, // just reuse same quantization, will sort out at the end before softmax
        10,
        -10
    );

    // --- Softmax 1: L13 ---
    // Input shape: 200
    // Output shape: 200
    model.addLayer<SoftmaxLayer>(
        LayerParams{sizeof(int8_t), {200}},
        LayerParams{sizeof(fp32), {200}},
        10,
        -10
    );

    return model;
}

void runBasicTest(const Model& model, const Path& basePath) {
    logInfo("--- Running Basic Test ---");

    // Load an image
    LayerData img = {{sizeof(fp32), {64, 64, 3}, "./data/image_0.bin"}};
    img.loadData();

    // Compare images
    std::cout << "Comparing image 0 to itself (max error): " << img.compare<fp32>(img) << std::endl
              << "Comparing image 0 to itself (T/F within epsilon " << ML::Config::EPSILON << "): " << std::boolalpha
              << img.compareWithin<fp32>(img, ML::Config::EPSILON) << std::endl;

    // Test again with a modified copy
    std::cout << "\nChange a value by 0.1 and compare again" << std::endl;
    
    LayerData imgCopy = img;
    imgCopy.get<fp32>(0) += 0.1;

    // Compare images
    img.compareWithinPrint<fp32>(imgCopy);

    // Test again with a modified copy
    log("Change a value by 0.1 and compare again...");
    imgCopy.get<fp32>(0) += 0.1;

    // Compare Images
    img.compareWithinPrint<fp32>(imgCopy);
}

void runLayerTest(const std::size_t layerNum, const Model& model, const Path& basePath) {
    // Load an image
    logInfo("--- Running Inference Test ---");
    dimVec inDims = {64, 64, 3};

    // Construct a LayerData object from a LayerParams one
    LayerData img({sizeof(fp32), inDims, basePath / "image_0.bin"});
    img.loadData();

    Timer timer("Layer Inference");

    // Run inference on the model
    timer.start();
    const LayerData output = model.inferenceLayer(img, layerNum, Layer::InfType::NAIVE);
    timer.stop();

    // Compare the output
    // Construct a LayerData object from a LayerParams one
    dimVec outDims = model[layerNum].getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / "image_0_data" / "layer_0_output.bin"});
    expected.loadData();
    output.compareWithinPrint<fp32>(expected);
}

void runLayerTestQuantized(const std::size_t layerNum, const Model& model, const Path& basePath) {
    // Load an image
    logInfo("--- Running Inference Test ---");
    dimVec inDims = {64, 64, 3};

    // Construct a LayerData object from a LayerParams one
    LayerData img({sizeof(fp32), inDims, basePath / "image_0.bin"});
    img.loadData();

    Timer timer("Layer Inference");

    // Run inference on the model
    timer.start();
    const LayerData output = model.inferenceLayer(img, layerNum, Layer::InfType::ACCELERATED);
    timer.stop();

    // Compare the output
    // Construct a LayerData object from a LayerParams one
    dimVec outDims = model[layerNum].getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / "image_0_data" / "layer_0_output.bin"});
    expected.loadData();
    output.compareWithinPrint<fp32>(expected);
}

void runLayerTestCompare(const std::size_t layerNum, const Model& model, const Path& basePath) {
    // Load an image
    logInfo("--- Running Inference Test ---");
    dimVec inDims = {64, 64, 3};

    // Construct a LayerData object from a LayerParams one
    LayerData img({sizeof(fp32), inDims, basePath / "image_0.bin"});
    img.loadData();

    Timer timer("Layer Inference");

    // Run inference on the model
    timer.start();
    const LayerData output = model.inferenceLayer(img, layerNum, Layer::InfType::NAIVE);
    timer.stop();

    const LayerData quantized_output = model.inferenceLayer(img, layerNum, Layer::InfType::ACCELERATED);

    output.compareWithinPrint<fp32>(quantized_output);
}

void runInferenceTest(const Model& model, const Path& basePath, int imageNum) {
    char imageName[32];
    char imageFolder[32];

    sprintf(imageName, "image_%d.bin", imageNum);
    sprintf(imageFolder, "image_%d_data", imageNum);

    // Load an image
    logInfo("--- Running Inference Test ---");
    dimVec inDims = {64, 64, 3};

    // Construct a LayerData object from a LayerParams one
    LayerData img({sizeof(fp32), inDims, basePath / imageName});
    img.loadData();

    Timer timer("Full Inference");

    // Run inference on the model
    timer.start();
    const LayerData output = model.inference(img, Layer::InfType::NAIVE);
    timer.stop();

    // Compare the output
    // Construct a LayerData object from a LayerParams one
    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / imageFolder / "layer_11_output.bin"});
    expected.loadData();
    output.compareWithinPrint<fp32>(expected);
}

void runInferenceCheckLayers(const Model& model, const Path& basePath) {
    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(fp32), inDims, basePath / "image_0.bin"});
    img.loadData();

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> outputs;
    outputs.push_back(img);

    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        outputs.push_back(model.inferenceLayer(outputs.at(i), i));
        char layer_file_name[32];
        sprintf(layer_file_name, "layer_%ld_output.bin", i);
        if(!((i + 2) >= model.getNumLayers())) {
            LayerData expected({sizeof(fp32), outputs.at(i + 1).getParams().dims, basePath / "image_0_data" / layer_file_name});
            expected.loadData();
            logInfo("Details for layer:");
            outputs.back().compareWithinPrint<fp32>(expected);
        }
    }

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / "image_0_data" / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    outputs.back().compareWithinPrint<fp32>(expected);
}

void runInferenceCheckLayersQuantized(const Model& model, const Path& basePath) {
    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(fp32), inDims, basePath / "image_0.bin"});
    img.loadData();

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> outputs;
    outputs.push_back(img);

    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        outputs.push_back(model.inferenceLayer(outputs.at(i), i, Layer::InfType::ACCELERATED));
        char layer_file_name[32];
        sprintf(layer_file_name, "layer_%ld_output.bin", i);
        if(!((i + 2) >= model.getNumLayers())) {
            LayerData expected({sizeof(fp32), outputs.at(i + 1).getParams().dims, basePath / "image_0_data" / layer_file_name});
            expected.loadData();
            logInfo("Details for layer:");
            outputs.back().compareWithinPrint<fp32>(expected);
        }
    }

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / "image_0_data" / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    outputs.back().compareWithinPrint<fp32>(expected);
}

// TODO see if this is needed
void runInferenceCheckLayersIntermediateQuantized(const Model& model, const Path& basePath) {
    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(int8_t), inDims, basePath / "image_0_quantized.bin"});
    img.loadData();

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> outputs;
    outputs.push_back(img);

    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        outputs.push_back(model.inferenceLayer(outputs.at(i), i, Layer::InfType::ACCELERATED));
        char layer_file_name[32];
        sprintf(layer_file_name, "layer_%ld_output.bin", i);
        if(!((i + 2) >= model.getNumLayers())) {
            LayerData expected({sizeof(int8_t), outputs.at(i + 1).getParams().dims, basePath / "image_0_data_quantized" / layer_file_name});
            expected.loadData();
            logInfo("Details for layer:");
            outputs.back().compareWithinPrint<int8_t>(expected);
        }
    }

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / "image_0_data_quantized" / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    outputs.back().compareWithinPrint<fp32>(expected);
}

void runInferenceCheckLayersQuantizedTest(const Model& model, const Path& basePath) {
    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(fp32), inDims, basePath / "image_0.bin"});
    img.loadData();

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> floatOutputs;
    std::vector<LayerData> int8Outputs;
    std::vector<LayerData> int4Outputs;
    std::vector<LayerData> int2Outputs;
    floatOutputs.push_back(img);
    int8Outputs.push_back(img);
    int4Outputs.push_back(img);
    int2Outputs.push_back(img);

    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        floatOutputs.push_back(model.inferenceLayer(floatOutputs.at(i), i, Layer::InfType::NAIVE));
        int8Outputs.push_back(model.inferenceLayer(floatOutputs.at(i), i, Layer::InfType::ACCELERATED, Layer::QuantType::INT8));
        int4Outputs.push_back(model.inferenceLayer(floatOutputs.at(i), i, Layer::InfType::ACCELERATED, Layer::QuantType::INT4));
        int2Outputs.push_back(model.inferenceLayer(floatOutputs.at(i), i, Layer::InfType::ACCELERATED, Layer::QuantType::INT2));
        
        char layer_file_name[32];
        sprintf(layer_file_name, "layer_%ld_output.bin", i);
        if(!((i + 2) >= model.getNumLayers())) {
            LayerData expected({sizeof(fp32), floatOutputs.at(i + 1).getParams().dims, basePath / "image_0_data" / layer_file_name});
            expected.loadData();
            logInfo("Details for layer:");
            floatOutputs.back().averageAbsoluteDiffPrint<fp32>(expected);
            int8Outputs.back().averageAbsoluteDiffPrint<fp32>(expected);
            int4Outputs.back().averageAbsoluteDiffPrint<fp32>(expected);
            int2Outputs.back().averageAbsoluteDiffPrint<fp32>(expected);
        }
    }

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / "image_0_data" / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    floatOutputs.back().averageAbsoluteDiffPrint<fp32>(expected);
    int8Outputs.back().averageAbsoluteDiffPrint<fp32>(expected);
    int4Outputs.back().averageAbsoluteDiffPrint<fp32>(expected);
    int2Outputs.back().averageAbsoluteDiffPrint<fp32>(expected);
}

void runInferenceDifferentQuantized(const Model& model, const Path& basePath) {
    logInfo("--- Running 1000 Image Test with custom quantization ---");
    
    char line[32];
    int classIndices[1000];

    FILE* metadata = fopen((basePath / "img_data/metadata.txt").c_str(), "r");
    while(fgets(line, 32, metadata)) {
        int index;
        int classIndex;
        if(sscanf(line, "%d,%d", &index, &classIndex) == 2) {
            classIndices[index] = classIndex;
        }
    }
    fclose(metadata);

    Layer::QuantType types[13];
    types[0] = Layer::QuantType::INT4;
    types[1] = Layer::QuantType::INT4;
    types[2] = Layer::QuantType::INT8; // doesn't matter, maxpool
    types[3] = Layer::QuantType::INT8;
    types[4] = Layer::QuantType::INT8;
    types[5] = Layer::QuantType::INT8; // doesn't matter, maxpool
    types[6] = Layer::QuantType::INT4;
    types[7] = Layer::QuantType::INT4;
    types[8] = Layer::QuantType::INT8; // doesn't matter, maxpool
    types[9] = Layer::QuantType::INT8; // doesn't matter, flatten
    types[10] = Layer::QuantType::INT8;
    types[11] = Layer::QuantType::INT8;
    types[12] = Layer::QuantType::INT8; // doesn't matter, softmax

    int numImages = 1000; // number of images to inference

    int numCorrect = 0;

    for(int i = 0; i < numImages; i++) {
        char filename[32];
        sprintf(filename, "image_%d.bin", i);

        logInfo("--- Running Inference Test ---");
        logInfo(filename);

        dimVec inDims = {64, 64, 3};

        LayerData img({sizeof(fp32), inDims, basePath / "img_data" / filename});
        img.loadData();

        std::vector<LayerData> outputs;
        outputs.push_back(img);

        for(unsigned long j = 0; j < model.getNumLayers(); j++) {
            outputs.push_back(model.inferenceLayer(outputs.at(j), j, Layer::InfType::ACCELERATED, types[j]));
        }

        unsigned int targetIndex = classIndices[i];

        dimVec outDims = model.getOutputLayer().getOutputParams().dims;

        size_t maxIndex = 0;
        for(size_t j = 0; j < outDims.at(0); j++) {
            if(model.getOutputLayer().getOutputData().get<fp32>(j) > model.getOutputLayer().getOutputData().get<fp32>(maxIndex)) {
                maxIndex = j;
            }
        }

        if(targetIndex == maxIndex) numCorrect++;
    }

    printf("Got %d images correct out of %d with custom quantization\n", numCorrect, numImages);
}

void runInferenceTimeLayers(const Model& model, const Path& basePath, int imageNum) {
    char imageName[32];
    char imageFolder[32];

    sprintf(imageName, "image_%d.bin", imageNum);
    sprintf(imageFolder, "image_%d_data", imageNum);

    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(fp32), inDims, basePath / imageName});
    img.loadData();

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> outputs;
    outputs.push_back(img);

    Timer fullTimer("Full Inference");

    fullTimer.start();
    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        char timerName[32];
        sprintf(timerName, "Layer %ld", i);
        Timer timer(timerName);
        timer.start();
        outputs.push_back(model.inferenceLayer(outputs.at(i), i));
        timer.stop();
    }
    fullTimer.stop();

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / imageFolder / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    outputs.back().compareWithinPrint<fp32>(expected);
}

void runInferenceTimeLayersQuantized(const Model& model, const Path& basePath, int imageNum) {
    char imageName[32];
    char imageFolder[32];

    sprintf(imageName, "image_%d.bin", imageNum);
    sprintf(imageFolder, "image_%d_data", imageNum);

    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(fp32), inDims, basePath / imageName});
    img.loadData();

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> outputs;
    outputs.push_back(img);

    Timer fullTimer("Full Inference");

    fullTimer.start();
    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        char timerName[32];
        sprintf(timerName, "Layer %ld", i);
        Timer timer(timerName);
        timer.start();
        outputs.push_back(model.inferenceLayer(outputs.at(i), i, Layer::InfType::ACCELERATED));
        timer.stop();
    }
    fullTimer.stop();

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / imageFolder / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    outputs.back().compareWithinPrint<fp32>(expected);
}

void runInferenceTimeLayersCustomQuantized(const Model& model, const Path& basePath, int imageNum) {
    char imageName[32];
    char imageFolder[32];

    sprintf(imageName, "image_%d.bin", imageNum);
    sprintf(imageFolder, "image_%d_data", imageNum);

    logInfo("--- Running Inference Test ---");
    logInfo("--- Checking after each layer ---");
    dimVec inDims = {64, 64, 3};

    // this code is basically copied from runInferenceTest() to set everything up
    LayerData img({sizeof(fp32), inDims, basePath / imageName});
    img.loadData();

    Layer::QuantType types[13];
    types[0] = Layer::QuantType::INT4;
    types[1] = Layer::QuantType::INT4;
    types[2] = Layer::QuantType::INT8; // doesn't matter, maxpool
    types[3] = Layer::QuantType::INT8;
    types[4] = Layer::QuantType::INT8;
    types[5] = Layer::QuantType::INT8; // doesn't matter, maxpool
    types[6] = Layer::QuantType::INT4;
    types[7] = Layer::QuantType::INT4;
    types[8] = Layer::QuantType::INT8; // doesn't matter, maxpool
    types[9] = Layer::QuantType::INT8; // doesn't matter, flatten
    types[10] = Layer::QuantType::INT8;
    types[11] = Layer::QuantType::INT8;
    types[12] = Layer::QuantType::INT8; // doesn't matter, softmax

    // const LayerData* outputs[model.getNumLayers() + 1];
    std::vector<LayerData> outputs;
    outputs.push_back(img);

    Timer fullTimer("Full Inference");

    fullTimer.start();
    for(unsigned long i = 0; i < model.getNumLayers(); i++) {
        char timerName[32];
        sprintf(timerName, "Layer %ld", i);
        Timer timer(timerName);
        timer.start();
        outputs.push_back(model.inferenceLayer(outputs.at(i), i, Layer::InfType::ACCELERATED, types[i]));
        timer.stop();
    }
    fullTimer.stop();

    dimVec outDims = model.getOutputLayer().getOutputParams().dims;
    LayerData expected({sizeof(fp32), outDims, basePath / imageFolder / "layer_11_output.bin"});
    expected.loadData();
    logInfo("Details for final layer:");
    outputs.back().compareWithinPrint<fp32>(expected);
}

void runThousandImageInferenceTest(const Model& model, const Path& basePath) {
    char line[32];
    int classIndices[1000];

    FILE* metadata = fopen((basePath / "img_data/metadata.txt").c_str(), "r");
    while(fgets(line, 32, metadata)) {
        int index;
        int classIndex;
        if(sscanf(line, "%d,%d", &index, &classIndex) == 2) {
            classIndices[index] = classIndex;
        }
    }
    fclose(metadata);

    int numQuantize8bitCorrect = 0;
    int numQuantize4bitCorrect = 0;
    int numQuantize2bitCorrect = 0;
    int numFloatCorrect = 0;

    float quantize8BitTimeMillis = 0.0f;
    float quantize4BitTimeMillis = 0.0f;
    float quantize2BitTimeMillis = 0.0f;
    float floatTimeMillis = 0.0f;

    int numImages = 1000; // number of images to inference

    for(int i = 0; i < numImages; i++) {
        char filename[32];
        sprintf(filename, "image_%d.bin", i);

        logInfo("--- Running Inference Test ---");
        logInfo(filename);

        dimVec inDims = {64, 64, 3};

        LayerData img({sizeof(fp32), inDims, basePath / "img_data" / filename});
        img.loadData();

        Timer quantize8BitTimer("8 bit quantization");
        quantize8BitTimer.start();
        model.inference(img, Layer::InfType::ACCELERATED);
        quantize8BitTimer.stop();

        quantize8BitTimeMillis += quantize8BitTimer.milliseconds;

        dimVec outDims = model.getOutputLayer().getOutputParams().dims;

        unsigned int targetIndex = classIndices[i];

        size_t maxIndex = 0;
        for(size_t j = 0; j < outDims.at(0); j++) {
            if(model.getOutputLayer().getOutputData().get<fp32>(j) > model.getOutputLayer().getOutputData().get<fp32>(maxIndex)) {
                maxIndex = j;
            }
        }

        if(targetIndex == maxIndex) numQuantize8bitCorrect++;

        Timer quantize4BitTimer("4 bit quantization");
        quantize4BitTimer.start();
        model.inference(img, Layer::InfType::ACCELERATED, Layer::QuantType::INT4);
        quantize4BitTimer.stop();

        quantize4BitTimeMillis += quantize4BitTimer.milliseconds;

        maxIndex = 0;
        for(size_t j = 0; j < outDims.at(0); j++) {
            if(model.getOutputLayer().getOutputData().get<fp32>(j) > model.getOutputLayer().getOutputData().get<fp32>(maxIndex)) {
                maxIndex = j;
            }
        }

        if(targetIndex == maxIndex) numQuantize4bitCorrect++;

        Timer quantize2BitTimer("2 bit quantization");
        quantize2BitTimer.start();
        model.inference(img, Layer::InfType::ACCELERATED, Layer::QuantType::INT2);
        quantize2BitTimer.stop();

        quantize2BitTimeMillis += quantize2BitTimer.milliseconds;

        maxIndex = 0;
        for(size_t j = 0; j < outDims.at(0); j++) {
            if(model.getOutputLayer().getOutputData().get<fp32>(j) > model.getOutputLayer().getOutputData().get<fp32>(maxIndex)) {
                maxIndex = j;
            }
        }

        if(targetIndex == maxIndex) numQuantize2bitCorrect++;

        Timer floatTimer("Float");
        floatTimer.start();
        model.inference(img, Layer::InfType::NAIVE);
        floatTimer.stop();

        floatTimeMillis += floatTimer.milliseconds;

        maxIndex = 0;
        for(size_t j = 0; j < outDims.at(0); j++) {
            if(model.getOutputLayer().getOutputData().get<fp32>(j) > model.getOutputLayer().getOutputData().get<fp32>(maxIndex)) {
                maxIndex = j;
            }
        }

        if(targetIndex == maxIndex) numFloatCorrect++;
    }

    printf("Got %d images correct out of %d with 8 bit quantization\n", numQuantize8bitCorrect, numImages);
    printf("Got %d images correct out of %d with 4 bit quantization\n", numQuantize4bitCorrect, numImages);
    printf("Got %d images correct out of %d with 2 bit quantization\n", numQuantize2bitCorrect, numImages);
    printf("Got %d images correct out of %d with naive\n", numFloatCorrect, numImages);
    printf("Took %f milliseconds on average for 8 bit quantized\n", quantize8BitTimeMillis / numImages);
    printf("Took %f milliseconds on average for 4 bit quantized\n", quantize4BitTimeMillis / numImages);
    printf("Took %f milliseconds on average for 2 bit quantized\n", quantize2BitTimeMillis / numImages);
    printf("Took %f milliseconds on average for naive\n", floatTimeMillis / numImages);
}

void runNImageTest(const Model& model, const Path& basePath, int numImages) {
    char line[32];
    int* classIndices = (int*) malloc(sizeof(int) * numImages);

    FILE* metadata = fopen((basePath / "img_data/metadata.txt").c_str(), "r");
    while(fgets(line, 32, metadata)) {
        int index;
        int classIndex;
        if(sscanf(line, "%d,%d", &index, &classIndex) == 2) {
            if(index >= numImages) break;
            classIndices[index] = classIndex;
        }
    }
    fclose(metadata);

    int numCorrect = 0;

    for(int i = 0; i < numImages; i++) {
        char filename[32];
        sprintf(filename, "image_%d.bin", i);

        logInfo("--- Running Inference Test ---");
        logInfo(filename);

        dimVec inDims = {64, 64, 3};

        LayerData img({sizeof(int8_t), inDims, basePath / "img_data_new" / filename});
        img.loadData();

        model.inference(img, Layer::InfType::ACCELERATED);

        dimVec outDims = model.getOutputLayer().getOutputParams().dims;

        unsigned int targetIndex = classIndices[i];

        size_t maxIndex = 0;
        for(size_t j = 0; j < outDims.at(0); j++) {
            if(model.getOutputLayer().getOutputData().get<fp32>(j) > model.getOutputLayer().getOutputData().get<fp32>(maxIndex)) {
                maxIndex = j;
            }
        }

        if(targetIndex == maxIndex) numCorrect++;

        printf("Inference %d, expected class %d, got class %ld\n", i, targetIndex, maxIndex);
        printf("Value for expected class was %f\n", model.getOutputLayer().getOutputData().get<fp32>(targetIndex));
    }

    printf("Of %d inferences, %d were correct (Top 1)\n", numImages, numCorrect);

    free(classIndices);
}

void runTests() {
    #ifdef ZEDBOARD
    Xil_DCacheDisable();
    #endif

    // Base input data path (determined from current directory of where you are running the command)
    Path basePath("data");  // May need to be altered for zedboards loading from SD Cards

    // Build the model and allocate the buffers
    Model model = buildToyModel(basePath / "model_new"); // pulling from new biases
    model.allocLayers();

    #ifdef ZEDBOARD
    runMemoryTest();
    #endif

    logInfo("Delaying...");

    // for(int i = 0; i < 1000000000; i++) {
    for(int i = 0; i < 10000000; i++) {
        asm("nop");
    }

    logInfo("Past delay");

    // runNImageTest(model, basePath, 50);

    runInferenceCheckLayersIntermediateQuantized(model, basePath);

    // Run some framework tests as an example of loading data
    // runBasicTest(model, basePath);

    // Run a layer inference test
    // runLayerTest(0, model, basePath);
    // runLayerTestQuantized(0, model, basePath);
    // runLayerTestCompare(0, model, basePath);

    // Run an end-to-end inference test
    // for(int i = 0; i < 3; i++) {
        // runInferenceTest(model, basePath, i);
        // runInferenceTimeLayers(model, basePath, i);
    // }

    // for(int i = 0; i < 3; i++) {
    //     runInferenceTimeLayersQuantized(model, basePath, i);
    // }

    // for(int i = 0; i < 3; i++) {
        // runInferenceTimeLayersCustomQuantized(model, basePath, i);
    // }

    // runThousandImageInferenceTest(model, basePath);
    // runInferenceDifferentQuantized(model, basePath);

    // Run a test and check the output at each layer
    // runInferenceCheckLayers(model, basePath);
    // runInferenceCheckLayersQuantized(model, basePath);

    // Check how each layer performs using different quantization
    // runInferenceCheckLayersQuantizedTest(model, basePath);
    // runInferenceDifferentQuantized(model, basePath);

    // Clean up
    model.freeLayers();
    std::cout << "\n\n----- ML::runTests() COMPLETE -----\n";
}

} // namespace ML

#ifdef ZEDBOARD
extern "C"
int main() {
    try {
        static FATFS fatfs;
        if (f_mount(&fatfs, "/", 1) != FR_OK) {
            throw std::runtime_error("Failed to mount SD card. Is it plugged in?");
        }
        ML::runTests();
    } catch (const std::exception& e) {
        std::cerr << "\n\n----- EXCEPTION THROWN -----\n" << e.what() << '\n';
    }
    std::cout << "\n\n----- STARTING FILE TRANSFER SERVER -----\n";
    FileServer::start_file_transfer_server();
}
#else
int main() {
    ML::runTests();
}
#endif
