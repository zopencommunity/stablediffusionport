#!/bin/bash
# Basic Stable Diffusion generation example for z/OS
./build/bin/sd \
    --model models/stable-diffusion-v1-5-pruned-emaonly-Q4_0.gguf \
    --prompt "mountain landscape" \
    --output example_output.png \
    --steps 20 \
    --seed 42
