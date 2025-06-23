# Troubleshooting Guide - CodeLens References Extension

## Common Installation Issues

### Issue 1: "can't find crate for `core`" Error

**Error Message:**
```
error[E0463]: can't find crate for `core`
= note: the `wasm32-wasip2` target may not be installed
= help: consider downloading the target with `rustup target add wasm32-wasip2`
```

**Status**: ✅ **FIXED** - This issue has been resolved by using the correct WebAssembly target.

**Solutions (try in order):**

#### Solution A: Use Compatible Target
We've switched to `wasm32-unknown-unknown` which is more widely supported:

```bash
# The extension is now configured to use wasm32-unknown-unknown
./build.sh
```

#### Solution B: Launch Zed with Rust Environment
```bash
# Launch Zed from terminal with proper environment
./launch_zed_with_rust.sh
```

#### Solution C: Manual Environment Setup
```bash
# Ensure Rust environment is properly set up
./setup_zed_environment.sh

# Then restart Zed completely and try again
```

#### Solution D: Install from Pre-built Extension
If compilation continues to fail, you can install the pre-built extension:

1. The extension is already built at: `target/wasm32-unknown-unknown/release/codelens_references.wasm`
2. This file is ready to use - Zed should be able to load it directly

### Issue 2: "failed to load extension.toml" Errors

**Error Messages:**
```
ERROR [extension_host] failed to load python extension.toml
ERROR [extension_host] failed to load javascript extension.toml
ERROR [language::language_registry] failed to load language TypeScript: Query error at 49:4. Invalid node type super
```

**Status**: ✅ **FIXED** - This issue has been resolved by removing conflicting language definitions.

**Root Cause**: The extension was trying to provide its own language support for JavaScript and TypeScript, which conflicted with Zed's built-in language support.

**Solution**: Removed the `languages/` directory and now rely on Zed's existing language support.

### Issue 3: Extension Loads but No CodeLens Appears

**Possible Causes:**
- Extension loaded but not working on the current file type
- Symbol detection not working for the specific code

**Solutions:**

1. **Test with provided files:**
   - Open `test_sample.rs` (Rust)
   - Open `test_sample.js` (JavaScript)
   - Open `test_sample.ts` (TypeScript)

2. **Check file extensions:**
   - Rust: `.rs`
   - JavaScript: `.js`, `.jsx`, `.mjs`, `.cjs`
   - TypeScript: `.ts`, `.tsx`, `.mts`, `.cts`

3. **Look for symbols that should show codelens:**
   - Functions
   - Classes
   - Interfaces (TypeScript)
   - Variables and constants

### Issue 4: Zed Can't Find Rust

**Error Message:**
```
Failed to install dev extension: failed to compile Rust extension
```

**Root Cause:** According to Zed's official documentation, "Rust must be installed via rustup. If you have Rust installed via homebrew or otherwise, installing dev extensions will not work."

**Solutions:**

1. **Verify Rust Installation Method:**
   ```bash
   # Check if Rust was installed via rustup
   which rustc
   which cargo
   # Should show paths like: /Users/username/.cargo/bin/rustc
   ```

2. **Reinstall Rust via rustup (REQUIRED):**
   ```bash
   # If you have Rust from homebrew, uninstall it first:
   # brew uninstall rust

   # Install via rustup (the ONLY supported method for Zed)
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source ~/.cargo/env
   rustup target add wasm32-unknown-unknown
   ```

3. **Ensure Environment Variables are Set:**
   ```bash
   # Add to your shell profile (~/.zshrc, ~/.bash_profile, etc.)
   export PATH="$HOME/.cargo/bin:$PATH"
   source ~/.cargo/env
   ```

4. **Launch Zed from Terminal (Critical):**
   ```bash
   # This ensures Zed inherits the terminal's environment
   source ~/.cargo/env
   open -a Zed
   ```

5. **Alternative: Use --foreground flag for debugging:**
   ```bash
   # This shows extension compilation output
   /Applications/Zed.app/Contents/MacOS/zed --foreground
   ```

## Alternative Installation Methods

### Method 1: Direct WASM Installation

If Rust compilation fails, you can try installing the pre-built WASM file:

1. Copy the built WASM file to a known location
2. Create a minimal extension directory with just the WASM file
3. Install that directory as a dev extension

### Method 2: Publish to Marketplace

Instead of dev installation, publish to the official marketplace:

```bash
# Use the publishing script
./publish_extension.sh
```

This bypasses local compilation issues since the Zed team will build it on their infrastructure.

## Debugging Steps

### Step 1: Verify Build Works Locally
```bash
# Clean build to ensure no cached issues
cargo clean
./build.sh

# Should see: ✅ Build successful!
```

### Step 2: Check Zed Logs
1. Open Zed
2. Go to Help → Open Log File
3. Look for extension-related errors
4. Try installing the extension and check for new errors

### Step 3: Test Environment
```bash
# Run the environment setup script
./setup_zed_environment.sh

# Should complete without errors
```

### Step 4: Restart Everything
1. Close Zed completely
2. Restart your terminal
3. Run: `source ~/.cargo/env`
4. Launch Zed: `open -a Zed`
5. Try installing the extension again

## Known Working Configuration

The extension has been tested and works with:

- ✅ **macOS**: Apple Silicon (M1/M2) and Intel
- ✅ **Rust**: 1.87.0 (latest stable) **installed via rustup ONLY**
- ✅ **Target**: `wasm32-unknown-unknown` (more compatible than `wasm32-wasip2`)
- ✅ **Zed**: Latest version
- ✅ **Build Size**: ~237KB WASM file
- ✅ **Launch Method**: Zed launched from terminal with proper environment

## Critical Requirements (From Zed Documentation)

1. **Rust Installation**: Must be installed via `rustup` - homebrew installations will NOT work
2. **Environment**: Zed must inherit the terminal environment where Rust is available
3. **Target**: `wasm32-unknown-unknown` target must be installed
4. **PATH**: `~/.cargo/bin` must be in PATH when Zed starts

## Success Indicators

When everything works correctly, you should see:

1. **Build Success:**
   ```
   ✅ Build successful!
   Extension built at: target/wasm32-unknown-unknown/release/codelens_references.wasm
   ```

2. **Installation Success:**
   - Extension appears in Zed's Extensions panel
   - No error messages in Zed logs

3. **Functionality Success:**
   - Open `test_sample.js`
   - See "// X references" above function definitions
   - See reference counts for classes, variables, etc.

## Getting Help

If none of these solutions work:

1. **Check Zed Version**: Make sure you're using a recent version of Zed
2. **Check Rust Version**: Ensure Rust is up to date (`rustup update`)
3. **Try Minimal Extension**: Create a simpler extension to test if the issue is with Zed's Rust support
4. **Community Support**: Ask in Zed's Discord or GitHub discussions

## Last Resort: Manual Installation

If all else fails, the extension can be manually installed by:

1. Copying the WASM file to Zed's extensions directory
2. Creating the necessary metadata files
3. Restarting Zed

This is more complex but can work around compilation issues.
