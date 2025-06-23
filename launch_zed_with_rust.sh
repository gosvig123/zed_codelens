#!/bin/bash

# Script to launch Zed with proper Rust environment

echo "🚀 Launching Zed with Rust environment..."

# Source Rust environment
source "$HOME/.cargo/env"

# Set environment variables
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
export PATH="$HOME/.cargo/bin:$PATH"

# Verify Rust is available
echo "✅ Rust version: $(rustc --version)"
echo "✅ Cargo version: $(cargo --version)"

# Show WebAssembly targets
echo "📋 Available WebAssembly targets:"
rustup target list --installed | grep wasm

echo ""
echo "🔧 Environment variables set:"
echo "RUSTUP_HOME: $RUSTUP_HOME"
echo "CARGO_HOME: $CARGO_HOME"
echo "PATH includes Rust: $(echo $PATH | grep -o '[^:]*cargo[^:]*')"

echo ""
echo "🚀 Launching Zed..."

# Launch Zed with the environment
open -a Zed

echo ""
echo "✅ Zed launched with Rust environment!"
echo ""
echo "📋 Now try installing the dev extension:"
echo "1. In Zed, press Cmd + Shift + X"
echo "2. Click 'Install Dev Extension'"
echo "3. Select this directory: $(pwd)"
echo ""
echo "💡 If it still fails, the issue might be that Zed needs to be built"
echo "   with Rust support or there's a version compatibility issue."
