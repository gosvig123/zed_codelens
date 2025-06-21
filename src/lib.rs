use zed_extension_api::{self as zed, CodeLabel, CodeLabelSpan, Range, Result};
use std::collections::HashMap;

struct CodelensExtension {
    cached_symbols: HashMap<String, Vec<SymbolInfo>>,
}

#[derive(Debug, Clone)]
struct SymbolInfo {
    name: String,
    kind: SymbolKind,
    line: u32,
    references: Vec<ReferenceLocation>,
}

#[derive(Debug, Clone)]
struct ReferenceLocation {
    line: u32,
    column: u32,
}

#[derive(Debug, Clone, PartialEq)]
enum SymbolKind {
    Function,
    Struct,
    Enum,
    Trait,
    Impl,
    Constant,
    Static,
    Module,
}

impl zed::Extension for CodelensExtension {
    fn new() -> Self {
        Self {
            cached_symbols: HashMap::new(),
        }
    }
}

impl CodelensExtension {
    /// Extract symbols from Rust code
    fn extract_symbols(&self, content: &str) -> Vec<SymbolInfo> {
        let mut symbols = Vec::new();

        for (line_num, line) in content.lines().enumerate() {
            let trimmed = line.trim();

            // Function definitions
            if let Some(name) = self.extract_function_name(trimmed) {
                let references = self.find_references(content, &name);
                symbols.push(SymbolInfo {
                    name,
                    kind: SymbolKind::Function,
                    line: line_num as u32 + 1,
                    references,
                });
            }

            // Struct definitions
            if let Some(name) = self.extract_struct_name(trimmed) {
                let references = self.find_references(content, &name);
                symbols.push(SymbolInfo {
                    name,
                    kind: SymbolKind::Struct,
                    line: line_num as u32 + 1,
                    references,
                });
            }

            // Enum definitions
            if let Some(name) = self.extract_enum_name(trimmed) {
                let references = self.find_references(content, &name);
                symbols.push(SymbolInfo {
                    name,
                    kind: SymbolKind::Enum,
                    line: line_num as u32 + 1,
                    references,
                });
            }

            // Trait definitions
            if let Some(name) = self.extract_trait_name(trimmed) {
                let references = self.find_references(content, &name);
                symbols.push(SymbolInfo {
                    name,
                    kind: SymbolKind::Trait,
                    line: line_num as u32 + 1,
                    references,
                });
            }

            // Constants
            if let Some(name) = self.extract_const_name(trimmed) {
                let references = self.find_references(content, &name);
                symbols.push(SymbolInfo {
                    name,
                    kind: SymbolKind::Constant,
                    line: line_num as u32 + 1,
                    references,
                });
            }
        }

        symbols
    }

    /// Find all references to a symbol in the text
    fn find_references(&self, content: &str, symbol_name: &str) -> Vec<ReferenceLocation> {
        let mut references = Vec::new();

        for (line_num, line) in content.lines().enumerate() {
            let mut start = 0;
            while let Some(pos) = line[start..].find(symbol_name) {
                let actual_pos = start + pos;

                // Check word boundaries
                let is_word_start = actual_pos == 0 ||
                    !line.chars().nth(actual_pos - 1).unwrap_or(' ').is_alphanumeric();
                let is_word_end = actual_pos + symbol_name.len() >= line.len() ||
                    !line.chars().nth(actual_pos + symbol_name.len()).unwrap_or(' ').is_alphanumeric();

                if is_word_start && is_word_end {
                    // Skip if this is the definition line
                    if !self.is_definition_line(line, symbol_name) {
                        references.push(ReferenceLocation {
                            line: line_num as u32 + 1,
                            column: actual_pos as u32 + 1,
                        });
                    }
                }

                start = actual_pos + 1;
            }
        }

        references
    }

    /// Check if a line contains a symbol definition
    fn is_definition_line(&self, line: &str, symbol_name: &str) -> bool {
        let trimmed = line.trim();

        // Check for various definition patterns
        (trimmed.contains("fn ") && trimmed.contains(symbol_name) && trimmed.contains('(')) ||
        (trimmed.contains("struct ") && trimmed.contains(symbol_name)) ||
        (trimmed.contains("enum ") && trimmed.contains(symbol_name)) ||
        (trimmed.contains("trait ") && trimmed.contains(symbol_name)) ||
        (trimmed.contains("const ") && trimmed.contains(symbol_name)) ||
        (trimmed.contains("static ") && trimmed.contains(symbol_name))
    }

    fn extract_function_name(&self, line: &str) -> Option<String> {
        if line.contains("fn ") {
            if let Some(fn_start) = line.find("fn ") {
                let after_fn = &line[fn_start + 3..];
                if let Some(paren_pos) = after_fn.find('(') {
                    let fn_name = after_fn[..paren_pos].trim();
                    if self.is_valid_identifier(fn_name) {
                        return Some(fn_name.to_string());
                    }
                }
            }
        }
        None
    }

    fn extract_struct_name(&self, line: &str) -> Option<String> {
        if line.contains("struct ") {
            if let Some(struct_start) = line.find("struct ") {
                let after_struct = &line[struct_start + 7..];
                let struct_name = after_struct
                    .split_whitespace()
                    .next()?
                    .trim_end_matches('{')
                    .trim_end_matches('<');

                if self.is_valid_identifier(struct_name) {
                    return Some(struct_name.to_string());
                }
            }
        }
        None
    }

    fn extract_enum_name(&self, line: &str) -> Option<String> {
        if line.contains("enum ") {
            if let Some(enum_start) = line.find("enum ") {
                let after_enum = &line[enum_start + 5..];
                let enum_name = after_enum
                    .split_whitespace()
                    .next()?
                    .trim_end_matches('{')
                    .trim_end_matches('<');

                if self.is_valid_identifier(enum_name) {
                    return Some(enum_name.to_string());
                }
            }
        }
        None
    }

    fn extract_trait_name(&self, line: &str) -> Option<String> {
        if line.contains("trait ") {
            if let Some(trait_start) = line.find("trait ") {
                let after_trait = &line[trait_start + 6..];
                let trait_name = after_trait
                    .split_whitespace()
                    .next()?
                    .trim_end_matches('{')
                    .trim_end_matches('<');

                if self.is_valid_identifier(trait_name) {
                    return Some(trait_name.to_string());
                }
            }
        }
        None
    }

    fn extract_const_name(&self, line: &str) -> Option<String> {
        if line.contains("const ") {
            if let Some(const_start) = line.find("const ") {
                let after_const = &line[const_start + 6..];
                if let Some(colon_pos) = after_const.find(':') {
                    let const_name = after_const[..colon_pos].trim();
                    if self.is_valid_identifier(const_name) {
                        return Some(const_name.to_string());
                    }
                }
            }
        }
        None
    }

    fn is_valid_identifier(&self, name: &str) -> bool {
        !name.is_empty() &&
        name.chars().all(|c| c.is_alphanumeric() || c == '_') &&
        !name.chars().next().unwrap_or('0').is_ascii_digit()
    }

    fn format_reference_count(&self, count: usize) -> String {
        match count {
            0 => "0 references".to_string(),
            1 => "1 reference".to_string(),
            n => format!("{} references", n),
        }
    }

    /// Public method to process a file and return CodeLens information
    pub fn process_file(&mut self, content: &str) -> Vec<(u32, String)> {
        let symbols = self.extract_symbols(content);
        let mut results = Vec::new();

        for symbol in symbols {
            let ref_count = symbol.references.len();
            let label = self.format_reference_count(ref_count);
            results.push((symbol.line, label));
        }

        results
    }
}

zed::register_extension!(CodelensExtension);
