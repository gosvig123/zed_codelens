#!/bin/bash

# Script to test if Zed can compile Rust extensions at all

echo "🧪 Testing Zed's Rust compilation capability..."

# Create a minimal test extension
TEST_DIR="test_minimal_extension"
mkdir -p "$TEST_DIR/src"

# Create minimal extension.toml
cat > "$TEST_DIR/extension.toml" << 'EOF'
id = "test-minimal"
name = "Test Minimal"
version = "0.1.0"
schema_version = 1
authors = ["Test <test@example.com>"]
description = "Minimal test extension"
EOF

# Create minimal Cargo.toml
cat > "$TEST_DIR/Cargo.toml" << 'EOF'
[package]
name = "test-minimal"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
zed_extension_api = "0.6.0"
EOF

# Create minimal lib.rs
cat > "$TEST_DIR/src/lib.rs" << 'EOF'
use zed_extension_api as zed;

struct TestExtension;

impl zed::Extension for TestExtension {
    fn new() -> Self {
        Self
    }
}

zed::register_extension!(TestExtension);
EOF

# Create .cargo/config.toml
mkdir -p "$TEST_DIR/.cargo"
cat > "$TEST_DIR/.cargo/config.toml" << 'EOF'
[build]
target = "wasm32-unknown-unknown"

[target.wasm32-unknown-unknown]
rustflags = ["-C", "target-feature=+bulk-memory"]
EOF

echo "✅ Created minimal test extension at: $TEST_DIR"

# Test compilation
cd "$TEST_DIR"
echo "🔨 Testing compilation..."

if cargo build --target wasm32-unknown-unknown --release; then
    echo "✅ Minimal extension compiles successfully!"
    echo "📦 WASM file: $(ls -la target/wasm32-unknown-unknown/release/*.wasm)"
    
    echo ""
    echo "🧪 Now test this minimal extension in Zed:"
    echo "1. Open Zed"
    echo "2. Go to Extensions (Cmd + Shift + X)"
    echo "3. Click 'Install Dev Extension'"
    echo "4. Select directory: $(pwd)"
    echo ""
    echo "If this minimal extension installs successfully, the issue is with"
    echo "the main extension's code. If it fails, the issue is with Zed's"
    echo "Rust compilation environment."
    
else
    echo "❌ Minimal extension compilation failed!"
    echo "This indicates a fundamental issue with the Rust/WebAssembly setup."
    echo ""
    echo "Try these steps:"
    echo "1. Update Rust: rustup update"
    echo "2. Reinstall wasm target: rustup target add wasm32-unknown-unknown"
    echo "3. Check Rust installation: rustc --version"
fi

cd ..

echo ""
echo "📁 Test extension created at: $TEST_DIR"
echo "🗑️  You can delete it after testing: rm -rf $TEST_DIR"
