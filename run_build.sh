#!/bin/bash

# Set CUDA compute capability manually since auto-detection may fail
# Common values: 70 (V100), 75 (T4), 80 (A100), 86 (RTX 3090), 89 (RTX 4090), 90 (H100)
export CUDA_COMPUTE_CAP=${CUDA_COMPUTE_CAP:-86}

# Use CUDA 12.8 - has better compatibility than 13.0
CUDA_VERSION=${CUDA_VERSION:-12.8}
CUDA_PATH="/usr/local/cuda-${CUDA_VERSION}"

if [ ! -d "$CUDA_PATH" ]; then
    echo "Error: CUDA $CUDA_VERSION not found at $CUDA_PATH"
    echo "Available CUDA versions:"
    ls -d /usr/local/cuda-* 2>/dev/null
    exit 1
fi

# Check if /usr/local/cuda points to the wrong version
CURRENT_CUDA=$(readlink -f /usr/local/cuda 2>/dev/null)
if [ "$CURRENT_CUDA" != "$CUDA_PATH" ]; then
    echo "WARNING: /usr/local/cuda points to $CURRENT_CUDA"
    echo "This project requires CUDA $CUDA_VERSION"
    echo ""
    echo "To fix this, run:"
    echo "  sudo rm /usr/local/cuda"
    echo "  sudo ln -s $CUDA_PATH /usr/local/cuda"
    echo ""
    echo "Or use update-alternatives:"
    echo "  sudo update-alternatives --set cuda $CUDA_PATH"
    echo ""
    echo "Attempting build anyway with environment overrides..."
fi

# Override all CUDA-related paths
export CUDA_HOME="$CUDA_PATH"
export CUDA_ROOT="$CUDA_PATH"
export CUDA_PATH="$CUDA_PATH"
export PATH="$CUDA_PATH/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_PATH/lib64:$LD_LIBRARY_PATH"

# Force include paths to only use our CUDA version
export CPATH="$CUDA_PATH/include"
export C_INCLUDE_PATH="$CUDA_PATH/include"
export CPLUS_INCLUDE_PATH="$CUDA_PATH/include"

# nvcc flags for compatibility
export NVCC_PREPEND_FLAGS="--allow-unsupported-compiler -I$CUDA_PATH/include"

# Tell bindgen_cuda where to find CUDA
export BINDGEN_CUDA_ROOT="$CUDA_PATH"

echo "=========================================="
echo "Building with CUDA compute capability: $CUDA_COMPUTE_CAP"
echo "Using CUDA path: $CUDA_PATH"
echo "nvcc location: $(which nvcc)"
echo "nvcc version: $(nvcc --version | grep release)"
echo "GCC version: $(gcc --version | head -1)"
echo "=========================================="

cargo build --release --features cuda
