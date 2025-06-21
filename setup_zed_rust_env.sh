#!/bin/bash

# Setup script to ensure Rust environment is properly configured for Zed
echo "Setting up Rust environment for Zed extension development..."

# Set up Rust environment variables
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
export PATH="$HOME/.cargo/bin:$PATH"

echo "Environment variables:"
echo "RUSTUP_HOME: $RUSTUP_HOME"
echo "CARGO_HOME: $CARGO_HOME"
echo "PATH: $PATH"

# Verify Rust installation
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"
echo "Rustup version: $(rustup --version)"

# Check installed targets
echo "Installed WebAssembly targets:"
rustup target list --installed | grep wasm

# Ensure required components are installed
echo "Installing required components..."
rustup component add rust-src
rustup target add wasm32-wasip2
rustup target add wasm32-wasip1
rustup target add wasm32-unknown-unknown

# Test compilation
echo "Testing compilation..."
cd /Users/kristian/Documents/augment-projects/zed_codelens
cargo build --target wasm32-wasip2 --release

echo "Setup complete! Now launching Zed with proper environment..."
open -a Zed
