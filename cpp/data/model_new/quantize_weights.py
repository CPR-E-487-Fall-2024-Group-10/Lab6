import sys
import struct
import numpy as np

scale = int(sys.argv[2])

weights = []

with open(sys.argv[1], 'rb') as weight_file:
    file_bytes = weight_file.read()
    
    for i in range(0, len(file_bytes) // 4):
        weights.append(struct.unpack('<f', file_bytes[(4*i):(4*i) + 4])[0])

quantized_data = []

for elem in weights:
    quantized = int((scale * elem))
    if quantized > 127:
        quantized = 127
    elif quantized < -128:
        quantized = -128
    
    quantized_data.append(quantized)

np_arr = np.array(quantized_data, dtype=np.int8)

# transpose the np array to get an array that has channels as most significant
# np_arr_transposed = np.transpose(np.reshape(np_arr, (3, 3, 64, 128)), (3, 2, 0, 1))
np_arr_transposed = np.transpose(np.reshape(np_arr, (4, 4, 128, 256)), (3, 2, 0, 1))

out_file = open(sys.argv[1], 'wb')
out_file.write(np_arr_transposed.tobytes())