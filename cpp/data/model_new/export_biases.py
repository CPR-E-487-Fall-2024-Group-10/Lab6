import csv
import sys
import struct
import numpy as np

input_scale = float(sys.argv[3])
weight_scale = float(sys.argv[4])
zero_point = int(sys.argv[5])

bias_scale = input_scale * weight_scale

biases = []

with open(sys.argv[1], 'rb') as bias_file:
    file_bytes = bias_file.read()

    for i in range(0, len(file_bytes) // 4):
        biases.append(struct.unpack('<f', file_bytes[(4*i):(4*i) + 4])[0])

print('Biases:')
print(biases)

biases_scaled = []
for bias in biases:
    biases_scaled.append(bias * bias_scale)

print('Biases Scaled:')
print(biases_scaled)

unique_values = []

with open(sys.argv[2], 'r') as csv_file:
    reader = csv.reader(csv_file, delimiter=',')
    for row in reader:
        for elem in row[:len(biases)]:
            unique_values.append(int(float(elem) * weight_scale))

print('Weight Sums:')
print(unique_values)

final_constants = []

for i in range(len(unique_values)):
    final_constants.append(int(biases_scaled[i]) - (zero_point * unique_values[i]))

print('Final Constants (' + str(len(final_constants)) + '):')
print(final_constants)

np_arr = np.array(final_constants, dtype=np.int32)

out_file = open(sys.argv[1], 'wb')
out_file.write(np_arr.tobytes())