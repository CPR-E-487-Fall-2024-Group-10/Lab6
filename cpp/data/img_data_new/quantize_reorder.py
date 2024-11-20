import sys
import struct
import numpy as np

scale = int(sys.argv[2])
zero_point = int(sys.argv[3])

img_data = []

with open(sys.argv[1], 'rb') as img_file:
    file_bytes = img_file.read()

    for i in range(0, len(file_bytes) // 4):
        img_data.append(struct.unpack('<f', file_bytes[(4*i):(4*i) + 4])[0])

quantized_data = []

for elem in img_data:
    quantized = int((scale * elem) + zero_point)
    if quantized > 127:
        quantized = 127
    elif quantized < -128:
        quantized = -128
    
    quantized_data.append(quantized)

np_arr = np.array(quantized_data, dtype=np.int8)

# transpose the np array to get an array that has channels as most significant
np_arr_transposed = np.transpose(np.reshape(np_arr, (64, 64, 3)), (2, 0, 1))

out_file = open(sys.argv[1], 'wb')
out_file.write(np_arr.tobytes())