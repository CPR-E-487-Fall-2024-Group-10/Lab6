#!/bin/bash

for i in $(seq 0 999);
do
    echo "Quantizing $i"
    python3 quantize_reorder.py "image_$i.bin" 255 -128
done