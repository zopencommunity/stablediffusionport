#!/bin/bash
# run_convert_fixed.sh - Run model conversion with forced memory allocation on z/OS

# Set environment variables to force memory allocation
export GGML_MEM_BUFFER_SIZE=2147483648  # 2GB
export GGML_N_THREADS=1
export GGML_USE_MMAP=0
export GGML_FORCE_CPU=1

# Run the conversion command
build/bin/sd \
    -M convert \
    -m models/v1-5-pruned-emaonly.safetensors \
    -o models/v1-5-ultra-small.ggml \
    --type q2_K \
    -v
