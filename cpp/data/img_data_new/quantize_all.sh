#!/bin/bash

for i in $(seq 0 999);
do
    python3 quantize_reorder.py "image_$i.bin" 244 -77
done