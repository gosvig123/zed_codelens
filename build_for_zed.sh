#!/bin/bash

# Build script for Zed extension
# This ensures the correct Rust environment is used

set -e

echo "Building CodeLens extension for Zed..."

# Source the Rust environment
source "$HOME/.cargo/env"

# Ensure we have the required targets
echo "Checking Rust targets..."
rustup target add wasm32-wasip2
rustup target add wasm32-unknown-unknown

# Show current Rust version
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"

# Clean previous builds
echo "Cleaning previous builds..."
cargo clean

# Build for wasm32-wasip2 (Zed's preferred target)
echo "Building for wasm32-wasip2..."
cargo build --target wasm32-wasip2 --release

# Also build for wasm32-unknown-unknown as fallback
echo "Building for wasm32-unknown-unknown..."
cargo build --target wasm32-unknown-unknown --release

echo "Build completed successfully!"
echo "WASM files generated:"
ls -lh target/*/release/*.wasm
