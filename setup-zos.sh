#!/bin/bash
# setup-zos.sh - z/OS environment setup for stable diffusion build

echo "Setting up z/OS build environment..."

# Set required environment variables
export _BPXK_AUTOCVT="ON"
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=""
export _TAG_REDIR_OUT=""
export _TAG_REDIR_ERR=""

# Create a wrapper for zopen that handles encoding
create_zopen_wrapper() {
    cat > ./zopen-wrapper.sh << 'WRAPPER_EOF'
#!/bin/bash
# Wrapper script to handle zopen build with proper encoding

# Set environment variables
export _BPXK_AUTOCVT="ON"
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=""
export _TAG_REDIR_OUT=""
export _TAG_REDIR_ERR=""

# Check if zopen-build needs conversion
ZOPEN_BUILD="/data/zopen/usr/local/bin/zopen-build"
if [ -f "$ZOPEN_BUILD" ]; then
    # Check file encoding
    FILE_TAG=$(ls -T "$ZOPEN_BUILD" 2>/dev/null | grep -o 'ISO8859-1\|UTF-8')
    if [ "$FILE_TAG" = "ISO8859-1" ] || [ "$FILE_TAG" = "UTF-8" ]; then
        echo "Converting zopen-build script encoding..."
        cp "$ZOPEN_BUILD" "${ZOPEN_BUILD}.backup" 2>/dev/null || true
        iconv -f ISO8859-1 -t IBM-1047 "${ZOPEN_BUILD}.backup" > "$ZOPEN_BUILD" 2>/dev/null || true
        chmod +x "$ZOPEN_BUILD"
    fi
fi

# Run zopen with arguments
zopen "$@"
WRAPPER_EOF
    chmod +x ./zopen-wrapper.sh
}

# Create the wrapper
create_zopen_wrapper

echo "z/OS environment setup complete!"
echo "Use './zopen-wrapper.sh build -v' instead of 'zopen build -v'"
