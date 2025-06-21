# CodeLens References Extension for Zed

A Zed extension that displays symbol references inline using tree-sitter, similar to VS Code's CodeLens feature.

## Features

- **Inline Reference Display**: Shows the number of references for functions, structs, and other symbols directly in the editor
- **Tree-sitter Integration**: Uses tree-sitter for accurate symbol detection and parsing
- **Multi-language Support**: Currently supports Rust, with plans to add more languages
- **Real-time Updates**: Reference counts update as you edit your code

## Installation

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

### From Zed Extensions Registry

Once published, you can install it directly from the Zed extensions registry:
- Open Zed
- Go to Extensions (Cmd/Ctrl + Shift + X)
- Search for "CodeLens References"
- Click Install

## Usage

Once installed, the extension will automatically:

1. **Detect Symbols**: Identify functions, structs, enums, traits, and other symbols in your Rust code
2. **Count References**: Find all references to each symbol within the current file
3. **Display Inline**: Show reference counts above symbol definitions

### Example

```rust
// 2 references
fn calculate_sum(a: i32, b: i32) -> i32 {
    a + b
}

// 1 reference  
struct Point {
    x: f64,
    y: f64,
}

fn main() {
    let result = calculate_sum(5, 3);  // Reference 1
    let point = Point { x: 1.0, y: 2.0 };  // Reference 1
    println!("Sum: {}", calculate_sum(10, 20));  // Reference 2
}
```

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
