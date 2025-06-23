#!/bin/bash

# Script to ensure Zed can find and use the Rust toolchain properly

echo "🔧 Setting up Rust environment for Zed..."

# Ensure Rust environment is sourced
source "$HOME/.cargo/env" 2>/dev/null || true

# Check if Rust is available
if ! command -v rustc &> /dev/null; then
    echo "❌ Rust not found in PATH. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

echo "✅ Rust version: $(rustc --version)"
echo "✅ Cargo version: $(cargo --version)"

# Ensure required targets are installed
echo "🎯 Installing required WebAssembly targets..."
rustup target add wasm32-wasip2
rustup target add wasm32-wasip1
rustup target add wasm32-unknown-unknown

# Show installed targets
echo "📋 Installed WebAssembly targets:"
rustup target list --installed | grep wasm

# Set environment variables that Zed might need
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
export PATH="$HOME/.cargo/bin:$PATH"

echo "🔧 Environment variables:"
echo "RUSTUP_HOME: $RUSTUP_HOME"
echo "CARGO_HOME: $CARGO_HOME"
echo "PATH includes: $HOME/.cargo/bin"

# Create a shell profile update to ensure these are always available
echo "📝 Updating shell profile..."

# Determine which shell profile to update
if [ -n "$ZSH_VERSION" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    PROFILE="$HOME/.bash_profile"
else
    PROFILE="$HOME/.profile"
fi

# Add Rust environment to profile if not already there
if ! grep -q "cargo/env" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Rust environment" >> "$PROFILE"
    echo 'source "$HOME/.cargo/env"' >> "$PROFILE"
    echo "✅ Added Rust environment to $PROFILE"
else
    echo "✅ Rust environment already in $PROFILE"
fi

# Test compilation to ensure everything works
echo "🧪 Testing WebAssembly compilation..."
cd "$(dirname "$0")"

# Clean and rebuild to ensure fresh compilation
cargo clean
if cargo build --target wasm32-wasip2 --release; then
    echo "✅ WebAssembly compilation successful!"
    echo "📦 Extension built at: target/wasm32-wasip2/release/codelens_references.wasm"
else
    echo "❌ WebAssembly compilation failed!"
    exit 1
fi

echo ""
echo "🚀 Environment setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Restart your terminal (or run: source ~/.cargo/env)"
echo "2. Restart Zed completely"
echo "3. Try installing the dev extension again"
echo ""
echo "💡 If you still have issues, try:"
echo "   - Restart your computer to ensure all environment variables are loaded"
echo "   - Open Zed from the terminal: open -a Zed"
echo "   - Check Zed's logs for more detailed error messages"
