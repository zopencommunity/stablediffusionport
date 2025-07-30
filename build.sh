#!/bin/bash
# build.sh - Complete z/OS build solution that doesn't modify system files

set -e

echo "Building Stable Diffusion for z/OS..."

# Set z/OS environment variables
export _BPXK_AUTOCVT="ON"
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=""
export _TAG_REDIR_OUT=""
export _TAG_REDIR_ERR=""

# Compile zoslib hooks if source exists but object doesn't
if [ ! -f ".zoslib_hooks/zoslib_env_hook.c.o" ] && [ -f ".zoslib_hooks/zoslib_env_hook.c" ]; then
    echo "Compiling z/OS library hooks..."
    cd .zoslib_hooks
    cc -c zoslib_env_hook.c -o zoslib_env_hook.c.o 2>/dev/null || \
    xlc -c zoslib_env_hook.c -o zoslib_env_hook.c.o 2>/dev/null || true
    cd ..
fi

# Create a temporary, safe wrapper for zopen that handles encoding
cat > ./temp_zopen_wrapper.sh << 'WRAPPER_EOF'
#!/bin/bash

# Set environment variables
export _BPXK_AUTOCVT="ON"  
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=""
export _TAG_REDIR_OUT=""
export _TAG_REDIR_ERR=""

# Create a temporary converted copy of zopen-build (not modifying original)
ZOPEN_BUILD="/data/zopen/usr/local/bin/zopen-build"
TEMP_ZOPEN_BUILD="./temp_zopen_build_converted"

if [ -f "$ZOPEN_BUILD" ]; then
    # Convert encoding to a temporary file
    iconv -f ISO8859-1 -t IBM-1047 "$ZOPEN_BUILD" > "$TEMP_ZOPEN_BUILD" 2>/dev/null || \
    iconv -f UTF-8 -t IBM-1047 "$ZOPEN_BUILD" > "$TEMP_ZOPEN_BUILD" 2>/dev/null || \
    cp "$ZOPEN_BUILD" "$TEMP_ZOPEN_BUILD"
    
    chmod +x "$TEMP_ZOPEN_BUILD"
    
    # Use our converted version
    "$TEMP_ZOPEN_BUILD" "$@"
    
    # Clean up
    rm -f "$TEMP_ZOPEN_BUILD"
else
    # Fallback to regular zopen if build script not found
    zopen "$@"
fi
WRAPPER_EOF

chmod +x ./temp_zopen_wrapper.sh

echo "Starting build with encoding-safe wrapper..."

# Use our temporary wrapper
./temp_zopen_wrapper.sh build -v

# Clean up temporary files
rm -f ./temp_zopen_wrapper.sh

echo "Build completed successfully!"
