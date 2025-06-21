#!/bin/bash

# Setup script to ensure Rust environment is available for Zed
echo "Setting up Rust environment for Zed..."

# Source the Rust environment
source "$HOME/.cargo/env"

# Ensure the required targets are installed
echo "Installing required WebAssembly targets..."
rustup target add wasm32-wasip2
rustup target add wasm32-unknown-unknown

# Show current setup
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"
echo "Installed targets:"
rustup target list --installed

# Set environment variables that Zed might need
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$HOME/.cargo/bin:$PATH"

echo "Environment setup complete!"
echo "CARGO_HOME: $CARGO_HOME"
echo "RUSTUP_HOME: $RUSTUP_HOME"
echo "PATH includes: $(echo $PATH | grep -o '[^:]*cargo[^:]*')"

# Try to make these available system-wide
echo "Attempting to make Rust available system-wide..."

# Create symlinks in /usr/local/bin if possible
if [ -w /usr/local/bin ]; then
    ln -sf "$HOME/.cargo/bin/rustc" /usr/local/bin/rustc
    ln -sf "$HOME/.cargo/bin/cargo" /usr/local/bin/cargo
    ln -sf "$HOME/.cargo/bin/rustup" /usr/local/bin/rustup
    echo "Created symlinks in /usr/local/bin"
else
    echo "Cannot create symlinks in /usr/local/bin (no write permission)"
fi
