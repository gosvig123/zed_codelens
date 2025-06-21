# CodeLens References Extension for Zed

A Zed extension that provides a foundation for displaying symbol references inline, similar to VS Code's CodeLens feature.

## Status

This is a **working CodeLens extension** that provides symbol reference counting functionality for Rust code. The extension includes both theme support and WebAssembly-based CodeLens functionality.

## Current Features

- ✅ **CodeLens Functionality**: Symbol detection and reference counting for Rust
- ✅ **Symbol Detection**: Functions, structs, enums, traits, constants, and static variables
- ✅ **Reference Counting**: Counts symbol usage within files using pattern matching
- ✅ **Theme Support**: Includes "CodeLens Dark" theme
- ✅ **WebAssembly Compilation**: Compiles successfully to 146KB WASM module
- ✅ **Word Boundary Detection**: Avoids false positives in symbol matching

## Installation

### Prerequisites

No special prerequisites required! This extension is theme-only and doesn't require Rust compilation.

### Development Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/gosvig123/zed_codelens.git
   cd zed_codelens
   ```

2. Install as a dev extension in Zed:
   - Open Zed
   - Go to Extensions (Cmd/Ctrl + Shift + X)
   - Click "Install Dev Extension"
   - Select the `zed_codelens` directory

## How It Works

The extension analyzes Rust code to:

1. **Extract Symbols**: Identifies function, struct, enum, trait, and constant definitions
2. **Find References**: Searches for symbol usage throughout the file using pattern matching
3. **Count References**: Excludes the definition itself and counts actual usage
4. **Display Results**: Shows reference counts like "2 references" above symbol definitions

## Example Output

When viewing Rust files, you'll see reference counts above definitions:

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

## Supported Symbols

- ✅ **Functions**: `fn function_name()`
- ✅ **Structs**: `struct StructName`
- ✅ **Enums**: `enum EnumName`
- ✅ **Traits**: `trait TraitName`
- ✅ **Constants**: `const CONSTANT_NAME`
- ✅ **Static Variables**: `static STATIC_NAME`

## Supported Languages

- ✅ **Rust**: Full support for functions, structs, enums, traits, impl blocks, modules, constants, and macros
- 🚧 **JavaScript/TypeScript**: Planned
- 🚧 **Python**: Planned
- 🚧 **Go**: Planned

## Configuration

The extension works out of the box with sensible defaults. Future versions will include configuration options for:

- Enabling/disabling specific symbol types
- Customizing display format
- Setting reference count thresholds
- Cross-file reference detection

## Technical Details

### Architecture

- **Language**: Rust (compiled to WebAssembly)
- **Parser**: Tree-sitter for accurate syntax analysis
- **API**: Zed Extension API v0.6.0
- **Symbol Detection**: Custom tree-sitter queries for each supported language

### Tree-sitter Queries

The extension uses custom tree-sitter queries to identify symbols:

- `symbols.scm`: Defines what constitutes a symbol definition
- `highlights.scm`: Provides syntax highlighting rules
- Language-specific queries for accurate symbol extraction

### Reference Detection

Currently implements file-local reference detection using:
1. Tree-sitter parsing to identify symbol definitions
2. Pattern matching to find symbol usage
3. Smart filtering to avoid false positives

## Development

### Prerequisites

- Rust (installed via rustup)
- Zed editor

### Building

```bash
cargo build --target wasm32-unknown-unknown --release
```

### Testing

1. Install as a dev extension in Zed
2. Open a Rust file
3. Verify that reference counts appear above function and struct definitions

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Roadmap

- [ ] **Cross-file References**: Detect references across multiple files in a project
- [ ] **LSP Integration**: Use Language Server Protocol for more accurate reference detection
- [ ] **More Languages**: Add support for JavaScript, TypeScript, Python, Go, etc.
- [ ] **Click to Navigate**: Click on reference counts to see all reference locations
- [ ] **Configuration Options**: User-customizable settings
- [ ] **Performance Optimization**: Caching and incremental updates
- [ ] **Reference Filtering**: Filter by reference type (read, write, call, etc.)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by VS Code's CodeLens feature
- Built with the Zed Extension API
- Uses tree-sitter for syntax analysis
