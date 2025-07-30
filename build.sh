#!/bin/bash
# build.sh - Robust build script for stable diffusion on z/OS
# This script forcibly handles all z/OS encoding issues

set -e

echo "Building Stable Diffusion for z/OS..."

# Set required environment variables
export _BPXK_AUTOCVT="ON"
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=""
export _TAG_REDIR_OUT=""
export _TAG_REDIR_ERR=""

echo "Setting up z/OS build environment with encoding fixes..."

# Force conversion of zopen-build script (this is the key fix)
ZOPEN_BUILD="/data/zopen/usr/local/bin/zopen-build"
if [ -f "$ZOPEN_BUILD" ]; then
    echo "Converting zopen-build script from ASCII to EBCDIC..."
    
    # Always make backup
    cp "$ZOPEN_BUILD" "${ZOPEN_BUILD}.backup.$(date +%s)" 2>/dev/null || true
    
    # Force conversion - don't try to detect, just convert
    iconv -f ISO8859-1 -t IBM-1047 "${ZOPEN_BUILD}.backup.$(date +%s)" > "$ZOPEN_BUILD.converted" 2>/dev/null || \
    iconv -f UTF-8 -t IBM-1047 "${ZOPEN_BUILD}.backup.$(date +%s)" > "$ZOPEN_BUILD.converted" 2>/dev/null || \
    cp "${ZOPEN_BUILD}.backup.$(date +%s)" "$ZOPEN_BUILD.converted"
    
    # Replace original with converted version
    mv "$ZOPEN_BUILD.converted" "$ZOPEN_BUILD"
    chmod +x "$ZOPEN_BUILD"
    
    echo "zopen-build script conversion completed"
fi

# Ensure zoslib hooks are compiled
if [ ! -f ".zoslib_hooks/zoslib_env_hook.c.o" ]; then
    echo "Compiling z/OS library hooks..."
    if [ -f ".zoslib_hooks/zoslib_env_hook.c" ]; then
        cd .zoslib_hooks
        cc -c zoslib_env_hook.c -o zoslib_env_hook.c.o 2>/dev/null || \
        xlc -c zoslib_env_hook.c -o zoslib_env_hook.c.o 2>/dev/null || true
        cd ..
        
        if [ -f ".zoslib_hooks/zoslib_env_hook.c.o" ]; then
            echo "zoslib hooks compiled successfully"
        else
            echo "Warning: Could not compile zoslib hooks, build may still work"
        fi
    fi
fi

echo "Starting build with converted zopen-build script..."

# Run zopen directly (no wrapper needed since we converted the script)
zopen build -v

echo "Build completed successfully!"
