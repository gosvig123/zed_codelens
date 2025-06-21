# CodeLens References Extension for Zed

A Zed extension that provides a foundation for displaying symbol references inline, similar to VS Code's CodeLens feature.

## Status

This is a **minimal working extension** that demonstrates the basic structure for a Zed extension. The full CodeLens functionality is planned for future implementation when Zed's extension API supports more advanced features.

## Current Features

- ✅ **Basic Extension Structure**: Properly configured Zed extension
- ✅ **Rust Compilation**: Compiles to WebAssembly successfully
- ✅ **Extension Registration**: Registers with Zed's extension system
- 🚧 **CodeLens Display**: Planned for future implementation

## Installation

### Prerequisites

1. **Rust**: Install via rustup
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source "$HOME/.cargo/env"
   rustup target add wasm32-unknown-unknown
   ```

### Development Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/gosvig123/zed_codelens.git
   cd zed_codelens
   ```

2. Build the extension:
   ```bash
   ./build.sh
   ```

3. Install as a dev extension in Zed:
   - Open Zed
   - Go to Extensions (Cmd/Ctrl + Shift + X)
   - Click "Install Dev Extension"
   - Select the `zed_codelens` directory

## Current Status

This extension currently provides:

- ✅ **Basic Extension Framework**: A working Zed extension that loads successfully
- ✅ **WebAssembly Compilation**: Rust code compiles to WASM for Zed
- ✅ **Extension Registration**: Properly registers with Zed's extension system

## Planned Features

The full CodeLens functionality will include:

- 🚧 **Symbol Detection**: Identify functions, structs, enums, traits in Rust code
- 🚧 **Reference Counting**: Count symbol usage within files
- 🚧 **Inline Display**: Show reference counts above definitions
- 🚧 **Multi-language Support**: Support for JavaScript, TypeScript, Python, etc.

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
