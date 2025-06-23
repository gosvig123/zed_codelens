# CodeLens References Extension for Zed

A Zed extension that displays symbol references inline, similar to VS Code's CodeLens feature, with support for Rust, JavaScript, and TypeScript including cross-file references.

## Status

This is a **fully functional CodeLens extension** that provides symbol reference counting functionality across multiple languages with cross-file reference detection.

## Current Features

- ✅ **Multi-Language Support**: Rust, JavaScript, and TypeScript
- ✅ **CodeLens Functionality**: Symbol detection and reference counting
- ✅ **Cross-File References**: Detects references across multiple files in the project
- ✅ **Symbol Detection**: Functions, classes, interfaces, types, variables, constants, and more
- ✅ **Import/Export Analysis**: Tracks symbols across module boundaries
- ✅ **Tree-sitter Integration**: Uses language-specific tree-sitter queries
- ✅ **WebAssembly Compilation**: Compiles successfully to optimized WASM module
- ✅ **Smart Symbol Filtering**: Shows codelens only for relevant symbol types

## Installation

### Prerequisites

1. **Rust**: Required for building the WebAssembly extension
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source "$HOME/.cargo/env"
   rustup target add wasm32-unknown-unknown
   ```

2. **Zed Editor**: Download and install from [zed.dev](https://zed.dev)

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

## Testing the Extension

The repository includes comprehensive test files to demonstrate the extension's capabilities:

### Single-File Tests
- `test_sample.rs` - Rust symbols and references
- `test_sample.js` - JavaScript symbols and references
- `test_sample.ts` - TypeScript symbols and references

### Cross-File Tests
- `test_cross_file.js` - JavaScript imports from `test_sample.js`
- `test_cross_file.ts` - TypeScript imports from `test_sample.ts`

Open any of these files in Zed to see the codelens functionality in action!

## How It Works

The extension analyzes Rust code to:

1. **Extract Symbols**: Identifies function, struct, enum, trait, and constant definitions
2. **Find References**: Searches for symbol usage throughout the file using pattern matching
3. **Count References**: Excludes the definition itself and counts actual usage
4. **Display Results**: Shows reference counts like "2 references" above symbol definitions

## Supported Languages

This extension works with Zed's built-in language support and provides codelens functionality for:

### Rust
- Functions, structs, enums, traits, constants, static variables
- Module-level symbol detection
- Public/private symbol analysis

### JavaScript
- Functions (declarations, expressions, arrow functions)
- Classes and methods
- Variables (const, let, var)
- Import/export statements
- Object methods

### TypeScript
- All JavaScript features plus:
- Interfaces and type aliases
- Enums and namespaces
- Generic types and type parameters
- Abstract classes
- Method and property signatures

**Note**: This extension leverages Zed's existing language support rather than providing its own language definitions, ensuring compatibility and avoiding conflicts.

## Example Output

When viewing code files, you'll see reference counts above symbol definitions:

### Rust
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

### JavaScript
```javascript
// 4 references (including cross-file)
function calculateArea(width, height) {
    return width * height;
}

// 5 references (including cross-file)
class Rectangle {
    constructor(width, height) {
        this.width = width;
        this.height = height;
    }
}
```

### TypeScript
```typescript
// 2 references (including cross-file)
interface Drawable {
    draw(): void;
}

// 4 references (including cross-file)
type Point = {
    x: number;
    y: number;
};

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
- **Cross-File Analysis**: Import/export tracking and module resolution

### Language Support Structure

```
languages/
├── rust/
│   ├── config.toml      # Language configuration
│   ├── highlights.scm   # Syntax highlighting rules
│   └── symbols.scm      # Symbol extraction queries
├── javascript/
│   ├── config.toml      # JavaScript configuration
│   ├── highlights.scm   # JS syntax highlighting
│   └── symbols.scm      # JS symbol queries
└── typescript/
    ├── config.toml      # TypeScript configuration
    ├── highlights.scm   # TS syntax highlighting
    └── symbols.scm      # TS symbol queries (includes interfaces, types)
```

### Tree-sitter Queries

Each language has specialized tree-sitter queries:

#### Rust (`languages/rust/symbols.scm`)
- Functions, structs, enums, traits
- Constants, static variables, modules
- Type aliases and macro definitions

#### JavaScript (`languages/javascript/symbols.scm`)
- Function declarations and expressions
- Arrow functions and class methods
- Variable declarations and exports
- Import/export statements

#### TypeScript (`languages/typescript/symbols.scm`)
- All JavaScript symbols plus:
- Interface and type alias declarations
- Enum and namespace declarations
- Generic type parameters
- Method and property signatures

### Reference Detection

The extension implements multi-level reference detection:

1. **Symbol Identification**: Tree-sitter parsing to identify symbol definitions
2. **Local References**: Pattern matching within the current file
3. **Cross-File References**: Import/export analysis across project files
4. **Smart Filtering**: Context-aware filtering to avoid false positives
5. **Caching**: Symbol and file caching for performance optimization

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
