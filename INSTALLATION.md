# Installation Guide - CodeLens References Extension

## Prerequisites

1. **Rust**: Make sure Rust is installed via rustup
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source "$HOME/.cargo/env"
   ```

2. **WebAssembly Target**: Add the WebAssembly compilation target
   ```bash
   rustup target add wasm32-wasip2
   ```

3. **Zed Editor**: Download and install Zed from [zed.dev](https://zed.dev)

## Building the Extension

1. **Clone or navigate to the extension directory**:
   ```bash
   cd zed_codelens
   ```

2. **Build the extension**:
   ```bash
   ./build.sh
   ```
   
   Or manually:
   ```bash
   cargo build --target wasm32-wasip2 --release
   ```

## Installing in Zed

### Method 1: Using the Build Script
After running `./build.sh`, follow the instructions printed to the console.

### Method 2: Manual Installation
1. Open Zed
2. Open the command palette (Cmd/Ctrl + Shift + P)
3. Type "Extensions" and select "zed: extensions"
4. Click "Install Dev Extension" button
5. Navigate to and select the `zed_codelens` directory
6. The extension should now be installed and active

## Testing the Extension

1. **Open the test file**: Open `test_sample.rs` in Zed
2. **Verify functionality**: You should see reference counts displayed above:
   - Function definitions (e.g., "2 references" above `calculate_area`)
   - Struct definitions (e.g., "3 references" above `Rectangle`)
   - Enum definitions
   - Trait definitions
   - Constants and static variables

## Expected Output

When viewing `test_sample.rs`, you should see inline text like:
```rust
// 2 references
fn calculate_area(width: f64, height: f64) -> f64 {
    width * height
}

// 3 references
struct Rectangle {
    width: f64,
    height: f64,
}
```

## Troubleshooting

### Extension Not Loading
- Check that the build completed successfully
- Verify the `.wasm` file exists in `target/wasm32-wasip2/release/`
- Try restarting Zed after installation

### No Reference Counts Showing
- Make sure you're viewing a Rust file (`.rs` extension)
- The current implementation only works within a single file
- Check the Zed console for any error messages

### Build Errors
- Ensure Rust is installed via rustup (not homebrew or other package managers)
- Verify the `wasm32-wasip2` target is installed
- Check that all dependencies in `Cargo.toml` are available

## Uninstalling

To remove the extension:
1. Open Zed
2. Go to Extensions (Cmd/Ctrl + Shift + X)
3. Find "CodeLens References" in the installed extensions
4. Click the uninstall button

## Development

To modify the extension:
1. Edit the source code in `src/lib.rs`
2. Rebuild with `./build.sh`
3. Restart Zed to reload the extension

## Limitations

Current version limitations:
- Only works with Rust files
- Reference detection is limited to the current file
- Uses simple pattern matching (not full tree-sitter integration yet)
- No cross-file reference detection
- No LSP integration

## Next Steps

Future improvements planned:
- Full tree-sitter integration
- Cross-file reference detection
- Support for more programming languages
- LSP integration for more accurate results
- Click-to-navigate functionality
