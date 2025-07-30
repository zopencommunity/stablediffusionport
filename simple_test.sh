#!/bin/bash
# simple_test.sh - Minimal CLI binary test for z/OS

SD_BINARY="build/bin/sd"

echo "=== Simple CLI Binary Test ==="
echo "Testing: $SD_BINARY"
echo "=============================="

# Test 1: Check if binary exists
if [ -f "$SD_BINARY" ]; then
    echo " Binary found"
    echo "   Size: $(ls -lh "$SD_BINARY" | awk '{print $5}')"
else
    echo " Binary not found at $SD_BINARY"
    exit 1
fi

# Test 2: Check if binary runs
if $SD_BINARY --help > /dev/null 2>&1; then
    echo " Binary executes successfully"
else
    echo " Binary failed to execute"
    exit 1
fi

# Test 3: Show basic info
echo " Binary info:"
echo "   $(file "$SD_BINARY" 2>/dev/null || echo "z/OS executable")"

echo ""
echo " SUCCESS: CLI binary is working on z/OS!"
echo "Ready to generate images once you have a model file."
