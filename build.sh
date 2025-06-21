#!/bin/bash

# Build script for Zed CodeLens Extension

set -e

echo "Building CodeLens References extension for Zed..."

# Check if Rust is installed
if ! command -v rustc &> /dev/null; then
    echo "Error: Rust is not installed. Please install Rust via rustup."
    echo "Visit: https://rustup.rs/"
    exit 1
fi

# Check if wasm32-unknown-unknown target is installed
if ! rustup target list --installed | grep -q "wasm32-unknown-unknown"; then
    echo "Installing wasm32-unknown-unknown target..."
    rustup target add wasm32-unknown-unknown
fi

# Build the extension
echo "Building WebAssembly module..."
cargo build --target wasm32-unknown-unknown --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "Extension built at: target/wasm32-unknown-unknown/release/codelens_references.wasm"
    echo ""
    echo "To install as a dev extension in Zed:"
    echo "1. Open Zed"
    echo "2. Go to Extensions (Cmd/Ctrl + Shift + X)"
    echo "3. Click 'Install Dev Extension'"
    echo "4. Select this directory: $(pwd)"
    echo ""
    echo "To test the extension:"
    echo "1. Open the test_sample.rs file in Zed"
    echo "2. You should see reference counts above function and struct definitions"
    echo ""
    echo "Note: This is a basic implementation. The extension will show reference counts"
    echo "for symbols within the current file only."
else
    echo "❌ Build failed!"
    exit 1
fi
