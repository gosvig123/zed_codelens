#!/bin/bash

# Script to publish CodeLens References extension to Zed marketplace

set -e

echo "🚀 Publishing CodeLens References Extension to Zed Marketplace"
echo "============================================================="

# Check if we're in the right directory
if [ ! -f "extension.toml" ]; then
    echo "❌ Error: extension.toml not found. Please run this script from the extension directory."
    exit 1
fi

# Check if git is configured
if ! git config user.name > /dev/null; then
    echo "❌ Error: Git user.name not configured. Please run:"
    echo "   git config --global user.name 'Your Name'"
    exit 1
fi

if ! git config user.email > /dev/null; then
    echo "❌ Error: Git user.email not configured. Please run:"
    echo "   git config --global user.email 'your.email@example.com'"
    exit 1
fi

echo "📋 Step 1: Preparing extension repository..."

# Make sure our extension repo is up to date and pushed
if [ -d ".git" ]; then
    echo "   - Adding and committing any changes..."
    git add .
    git commit -m "Prepare extension for marketplace submission" || echo "   - No changes to commit"
    
    echo "   - Pushing to GitHub..."
    git push origin main || git push origin master
else
    echo "❌ Error: This directory is not a git repository. Please initialize git first."
    exit 1
fi

echo "📋 Step 2: Setting up extensions repository..."

# Create a temporary directory for the extensions repo
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "   - Cloning Zed extensions repository..."
git clone https://github.com/zed-industries/extensions.git
cd extensions

echo "   - Initializing submodules..."
git submodule init
git submodule update

echo "📋 Step 3: Adding extension as submodule..."

# Add our extension as a submodule
echo "   - Adding codelens-references submodule..."
git submodule add https://github.com/gosvig123/zed_codelens.git extensions/codelens-references

echo "📋 Step 4: Updating extensions.toml..."

# Check if extensions.toml exists
if [ ! -f "extensions.toml" ]; then
    echo "❌ Error: extensions.toml not found in the extensions repository."
    exit 1
fi

# Add our extension to extensions.toml
echo "   - Adding entry to extensions.toml..."
cat >> extensions.toml << 'EOF'

[codelens-references]
submodule = "extensions/codelens-references"
version = "0.1.0"
EOF

echo "📋 Step 5: Sorting extensions..."

# Check if pnpm is available
if command -v pnpm > /dev/null; then
    echo "   - Sorting extensions with pnpm..."
    pnpm sort-extensions
else
    echo "   ⚠️  Warning: pnpm not found. You may need to sort extensions.toml manually."
fi

echo "📋 Step 6: Creating commit..."

git add .
git commit -m "Add CodeLens References extension

- Multi-language support for Rust, JavaScript, and TypeScript
- Cross-file reference detection  
- Inline reference counting similar to VS Code CodeLens
- Tree-sitter based symbol detection
- Comprehensive test files and documentation"

echo "✅ Extension prepared for submission!"
echo ""
echo "📋 Next Steps:"
echo "1. Fork the Zed extensions repository on GitHub:"
echo "   https://github.com/zed-industries/extensions"
echo ""
echo "2. Push the changes to your fork:"
echo "   cd $TEMP_DIR/extensions"
echo "   git remote add fork https://github.com/gosvig123/extensions.git"
echo "   git push fork main"
echo ""
echo "3. Create a Pull Request on GitHub from your fork to zed-industries/extensions"
echo ""
echo "4. Wait for review and approval from the Zed team"
echo ""
echo "📁 Extensions repository prepared at: $TEMP_DIR/extensions"
echo ""
echo "🎉 Once merged, users will be able to install your extension directly from Zed!"

# Keep the temp directory for manual steps
echo ""
echo "💡 Tip: The temporary directory will remain at $TEMP_DIR for you to complete the manual steps."
