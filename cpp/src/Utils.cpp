#include "Utils.h"

namespace ML {

    float relu(float x) {
        if(x < 0.0f) {
            return 0.0f;
        }

        return x;
    }

    int32_t relu(int32_t x, int32_t zero_point) {
        if(x < zero_point){
            return zero_point;
        }

        return x;
    }

}  // namespace ML