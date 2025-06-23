#!/bin/bash

# Definitive fix for Zed extension compilation issues
# Based on official Zed documentation and research

echo "🔧 Fixing Zed Rust Environment for Extension Development"
echo "========================================================"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  This script is designed for macOS. Adjust paths for other systems."
fi

echo "📋 Step 1: Checking current Rust installation..."

# Check if Rust is installed
if command -v rustc &> /dev/null; then
    echo "✅ Rust found: $(rustc --version)"
    RUST_PATH=$(which rustc)
    echo "📍 Rust location: $RUST_PATH"
    
    # Check if it's from rustup (required by Zed)
    if [[ "$RUST_PATH" == *".cargo/bin/rustc" ]]; then
        echo "✅ Rust is installed via rustup (correct for Zed)"
    else
        echo "❌ Rust is NOT installed via rustup!"
        echo "   Zed requires Rust to be installed via rustup."
        echo "   Current path: $RUST_PATH"
        
        if [[ "$RUST_PATH" == *"homebrew"* ]] || [[ "$RUST_PATH" == *"/usr/local/bin"* ]]; then
            echo "⚠️  Detected homebrew Rust installation - this will NOT work with Zed"
            echo "   You need to uninstall homebrew Rust and install via rustup"
            echo ""
            echo "   Run these commands:"
            echo "   brew uninstall rust"
            echo "   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
            exit 1
        fi
    fi
else
    echo "❌ Rust not found! Installing via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

echo ""
echo "📋 Step 2: Ensuring required WebAssembly targets..."

# Install required targets
rustup target add wasm32-unknown-unknown
rustup target add wasm32-wasip2  # For compatibility

echo "✅ Installed targets:"
rustup target list --installed | grep wasm

echo ""
echo "📋 Step 3: Setting up environment variables..."

# Determine shell profile
if [ -n "$ZSH_VERSION" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    PROFILE="$HOME/.bash_profile"
else
    PROFILE="$HOME/.profile"
fi

echo "📝 Updating shell profile: $PROFILE"

# Backup profile
cp "$PROFILE" "$PROFILE.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true

# Add Rust environment if not already there
if ! grep -q "cargo/env" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Rust environment (required for Zed extensions)" >> "$PROFILE"
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$PROFILE"
    echo 'source "$HOME/.cargo/env"' >> "$PROFILE"
    echo "✅ Added Rust environment to $PROFILE"
else
    echo "✅ Rust environment already in $PROFILE"
fi

# Source the environment
source "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

echo ""
echo "📋 Step 4: Testing compilation..."

# Test if our extension compiles
cd "$(dirname "$0")"
if [ -f "Cargo.toml" ]; then
    echo "🧪 Testing extension compilation..."
    cargo clean
    if cargo build --target wasm32-unknown-unknown --release; then
        echo "✅ Extension compiles successfully!"
        WASM_SIZE=$(ls -lh target/wasm32-unknown-unknown/release/*.wasm | awk '{print $5}')
        echo "📦 WASM file size: $WASM_SIZE"
    else
        echo "❌ Extension compilation failed!"
        echo "   This indicates a code issue, not an environment issue."
    fi
else
    echo "⚠️  No Cargo.toml found - skipping compilation test"
fi

echo ""
echo "📋 Step 5: Environment verification..."

echo "✅ Environment check:"
echo "   Rust version: $(rustc --version)"
echo "   Cargo version: $(cargo --version)"
echo "   Rust path: $(which rustc)"
echo "   Cargo path: $(which cargo)"
echo "   PATH includes cargo: $(echo $PATH | grep -o '[^:]*cargo[^:]*' || echo 'NOT FOUND')"

echo ""
echo "🚀 Final Steps for Zed:"
echo "========================"
echo ""
echo "1. 🔄 RESTART your terminal completely"
echo "   - Close all terminal windows"
echo "   - Open a new terminal"
echo ""
echo "2. 🚀 Launch Zed from the terminal:"
echo "   source ~/.cargo/env"
echo "   open -a Zed"
echo ""
echo "3. 📦 Install the extension:"
echo "   - In Zed: Cmd + Shift + X"
echo "   - Click 'Install Dev Extension'"
echo "   - Select this directory: $(pwd)"
echo ""
echo "4. 🐛 If it still fails, debug with:"
echo "   /Applications/Zed.app/Contents/MacOS/zed --foreground"
echo "   (This shows compilation output)"
echo ""
echo "💡 Key Points:"
echo "   - Zed MUST be launched from a terminal with Rust in PATH"
echo "   - Rust MUST be installed via rustup (not homebrew)"
echo "   - Environment variables must be loaded before launching Zed"
echo ""
echo "✅ Environment setup complete!"
