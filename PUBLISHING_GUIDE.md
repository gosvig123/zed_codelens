# Publishing Guide - CodeLens References Extension

## Overview

To make your extension available in the Zed marketplace (so users can install it directly from within Zed), you need to submit it to the official Zed extensions repository.

## Prerequisites

1. **GitHub Account**: You need a GitHub account
2. **Extension Repository**: Your extension should be in a public GitHub repository
3. **Working Extension**: Your extension should build and work correctly

## Method 1: Automated Script (Recommended)

I've created a script to automate most of the process:

```bash
# Run the publishing script
./publish_extension.sh
```

This script will:
- ✅ Prepare your extension repository
- ✅ Clone the Zed extensions repository
- ✅ Add your extension as a submodule
- ✅ Update the extensions registry
- ✅ Create the necessary commits

## Method 2: Manual Process

### Step 1: Fork the Extensions Repository

1. Go to: https://github.com/zed-industries/extensions
2. Click "Fork" to create your own copy
3. Clone your fork:

```bash
git clone https://github.com/gosvig123/extensions.git
cd extensions
git submodule init
git submodule update
```

### Step 2: Add Your Extension

```bash
# Add your extension as a submodule
git submodule add https://github.com/gosvig123/zed_codelens.git extensions/codelens-references
git add extensions/codelens-references
```

### Step 3: Update Extensions Registry

Edit `extensions.toml` and add your extension (in alphabetical order):

```toml
[codelens-references]
submodule = "extensions/codelens-references"
version = "0.1.0"
```

### Step 4: Sort Extensions

```bash
# If you have pnpm installed
pnpm sort-extensions

# This ensures extensions.toml and .gitmodules are properly sorted
```

### Step 5: Create Pull Request

```bash
# Commit your changes
git add .
git commit -m "Add CodeLens References extension

- Multi-language support for Rust, JavaScript, and TypeScript
- Cross-file reference detection
- Inline reference counting similar to VS Code CodeLens
- Tree-sitter based symbol detection"

# Push to your fork
git push origin main
```

Then create a Pull Request on GitHub from your fork to `zed-industries/extensions`.

## What Happens After Submission

1. **Review Process**: The Zed team will review your extension
2. **Testing**: They'll test that it builds and works correctly
3. **Feedback**: You may receive feedback or requests for changes
4. **Approval**: Once approved, your PR will be merged
5. **Publication**: Your extension becomes available in the Zed marketplace

## Extension Requirements

Your extension must meet these requirements:

### ✅ **Technical Requirements**
- Builds successfully with `cargo build --target wasm32-wasip2 --release`
- Uses the latest compatible `zed_extension_api` version
- Follows Zed's extension guidelines
- Has proper `extension.toml` metadata

### ✅ **Quality Requirements**
- Works as described
- Doesn't crash or cause performance issues
- Has reasonable resource usage
- Provides value to users

### ✅ **Documentation Requirements**
- Clear README with installation and usage instructions
- Proper description in `extension.toml`
- Examples or test files (like we have)

## Your Extension Status

Your CodeLens References extension meets all requirements:

- ✅ **Builds Successfully**: Uses correct `wasm32-wasip2` target
- ✅ **Multi-Language Support**: Rust, JavaScript, TypeScript
- ✅ **Cross-File References**: Advanced functionality
- ✅ **Comprehensive Tests**: Multiple test files included
- ✅ **Good Documentation**: README, installation guides, examples
- ✅ **Proper Metadata**: Correct `extension.toml` configuration

## Timeline

- **Submission**: Immediate (once you create the PR)
- **Review**: Usually 1-7 days depending on complexity
- **Publication**: Immediate after approval

## After Publication

Once published, users can install your extension by:

1. Opening Zed
2. Going to Extensions (Cmd/Ctrl + Shift + X)
3. Searching for "CodeLens References"
4. Clicking "Install"

## Tips for Success

1. **Clear Description**: Make sure your extension description clearly explains what it does
2. **Good Examples**: Include test files that demonstrate the functionality
3. **Responsive to Feedback**: Address any review comments quickly
4. **Follow Guidelines**: Stick to Zed's extension development best practices

## Support

If you encounter issues during the submission process:

1. Check the [Zed Extensions Documentation](https://zed.dev/docs/extensions)
2. Look at other extensions in the repository for examples
3. Ask questions in the Zed community Discord or GitHub discussions

Your extension is ready for publication! 🚀
