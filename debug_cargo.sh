#!/bin/bash

# Debug script to see what Zed is doing
echo "=== CARGO DEBUG WRAPPER ===" >> /tmp/zed_cargo_debug.log
echo "Date: $(date)" >> /tmp/zed_cargo_debug.log
echo "PWD: $(pwd)" >> /tmp/zed_cargo_debug.log
echo "PATH: $PATH" >> /tmp/zed_cargo_debug.log
echo "CARGO_HOME: $CARGO_HOME" >> /tmp/zed_cargo_debug.log
echo "RUSTUP_HOME: $RUSTUP_HOME" >> /tmp/zed_cargo_debug.log
echo "Args: $@" >> /tmp/zed_cargo_debug.log
echo "Rust version: $(rustc --version 2>&1)" >> /tmp/zed_cargo_debug.log
echo "Cargo version: $(cargo --version 2>&1)" >> /tmp/zed_cargo_debug.log
echo "Targets: $(rustup target list --installed 2>&1)" >> /tmp/zed_cargo_debug.log
echo "=========================" >> /tmp/zed_cargo_debug.log

# Source the Rust environment
source "$HOME/.cargo/env"

# Run the actual cargo command
exec /Users/kristian/.cargo/bin/cargo "$@"
