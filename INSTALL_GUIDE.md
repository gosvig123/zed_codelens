# Installation Guide - CodeLens References Extension

## Quick Installation Steps

### 1. Build the Extension
```bash
cd /Users/kristian/Documents/augment-projects/zed_codelens
./build.sh
```

### 2. Install in Zed
1. Open Zed
2. Press `Cmd + Shift + X` (or go to Extensions menu)
3. Click "Install Dev Extension"
4. Navigate to and select: `/Users/kristian/Documents/augment-projects/zed_codelens`
5. Click "Open" or "Select"

### 3. Verify Installation
- The extension should appear in your installed extensions list
- You should see "CodeLens References" in the extensions panel

## Testing the Extension

### Test Files Available:
1. **`test_sample.rs`** - Rust symbols and references
2. **`test_sample.js`** - JavaScript symbols and references
3. **`test_sample.ts`** - TypeScript symbols and references
4. **`test_cross_file.js`** - Cross-file JavaScript references
5. **`test_cross_file.ts`** - Cross-file TypeScript references

### What You Should See:
When you open any of these test files, you should see reference counts above symbol definitions like:

```rust
// 2 references
fn calculate_area(width: f64, height: f64) -> f64 {
    width * height
}
```

```javascript
// 4 references (including cross-file)
function calculateArea(width, height) {
    return width * height;
}
```

```typescript
// 2 references (including cross-file)
interface Drawable {
    draw(): void;
}
```

## Troubleshooting

### If the extension doesn't load:
1. Check that the build was successful (you should see "✅ Build successful!")
2. Make sure you're selecting the correct directory (`zed_codelens`)
3. Try restarting Zed after installation
4. Check the Zed logs for any error messages

### If you don't see codelens:
1. Make sure you're opening one of the test files
2. The codelens only appears above symbol definitions (functions, classes, etc.)
3. Try opening `test_sample.js` or `test_sample.ts` which have many symbols

### If you get build errors:
1. Make sure Rust is installed: `rustc --version`
2. Make sure the wasm target is installed: `rustup target add wasm32-unknown-unknown`
3. Try cleaning and rebuilding: `cargo clean && ./build.sh`

## Features Demonstrated

- ✅ **Multi-language support**: Rust, JavaScript, TypeScript
- ✅ **Cross-file references**: References across multiple files
- ✅ **Symbol detection**: Functions, classes, interfaces, types, variables
- ✅ **Smart filtering**: Only shows codelens for relevant symbols
- ✅ **Import/export tracking**: Understands module relationships

## Next Steps

Once installed, you can:
1. Open any of the test files to see the extension in action
2. Try creating your own JavaScript/TypeScript files to test
3. Experiment with cross-file references by importing symbols between files
4. Explore the language configurations in the `languages/` directory

The extension is now ready to use with full JavaScript and TypeScript support including cross-file reference detection!
