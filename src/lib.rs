use zed_extension_api::{self as zed, CodeLabel, CodeLabelSpan, Result, LanguageServerId, Worktree, Range};
use std::collections::HashMap;
use serde_json::Value;

struct CodelensExtension {
    cached_references: HashMap<String, Vec<ReferenceInfo>>,
    enabled_languages: Vec<String>,
}

#[derive(Debug, Clone)]
struct ReferenceInfo {
    symbol_name: String,
    file_path: String,
    line: u32,
    column: u32,
    symbol_kind: SymbolKind,
}

#[derive(Debug, Clone, PartialEq)]
enum SymbolKind {
    Function,
    Struct,
    Enum,
    Trait,
    Impl,
    Module,
    Constant,
    Static,
    TypeAlias,
    Macro,
    Variable,
}

impl zed::Extension for CodelensExtension {
    fn new() -> Self {
        Self {
            cached_references: HashMap::new(),
            enabled_languages: vec!["rust".to_string(), "javascript".to_string(), "typescript".to_string()],
        }
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        _worktree: &Worktree,
    ) -> Result<zed::process::Command> {
        Err("Language server command not implemented".to_string())
    }

    fn language_server_initialization_options(
        &mut self,
        _language_server_id: &LanguageServerId,
        _worktree: &Worktree,
    ) -> Result<Option<Value>> {
        Ok(None)
    }

    fn language_server_workspace_configuration(
        &mut self,
        _language_server_id: &LanguageServerId,
        _worktree: &Worktree,
    ) -> Result<Option<Value>> {
        Ok(None)
    }
}

impl CodelensExtension {
    /// Find all references to a symbol in the given text using pattern matching
    /// This is a simplified implementation - in production, this would use tree-sitter or LSP
    fn find_references(&self, text: &str, symbol_name: &str, symbol_kind: SymbolKind) -> Vec<ReferenceInfo> {
        let mut references = Vec::new();

        for (line_num, line) in text.lines().enumerate() {
            let mut start = 0;
            while let Some(pos) = line[start..].find(symbol_name) {
                let actual_pos = start + pos;

                // Check if it's a word boundary
                let is_word_start = actual_pos == 0 ||
                    !line.chars().nth(actual_pos - 1).unwrap_or(' ').is_alphanumeric();
                let is_word_end = actual_pos + symbol_name.len() >= line.len() ||
                    !line.chars().nth(actual_pos + symbol_name.len()).unwrap_or(' ').is_alphanumeric();

                if is_word_start && is_word_end {
                    // Skip if this is the definition line (simple heuristic)
                    let is_definition = self.is_definition_line(line, symbol_name, &symbol_kind);

                    if !is_definition {
                        references.push(ReferenceInfo {
                            symbol_name: symbol_name.to_string(),
                            file_path: "current_file".to_string(),
                            line: line_num as u32 + 1,
                            column: actual_pos as u32 + 1,
                            symbol_kind: symbol_kind.clone(),
                        });
                    }
                }

                start = actual_pos + 1;
            }
        }

        references
    }

    /// Check if a line contains the definition of a symbol
    fn is_definition_line(&self, line: &str, symbol_name: &str, symbol_kind: &SymbolKind) -> bool {
        let trimmed = line.trim();

        match symbol_kind {
            SymbolKind::Function => {
                trimmed.contains("fn ") && trimmed.contains(symbol_name) && trimmed.contains('(')
            },
            SymbolKind::Struct => {
                trimmed.contains("struct ") && trimmed.contains(symbol_name)
            },
            SymbolKind::Enum => {
                trimmed.contains("enum ") && trimmed.contains(symbol_name)
            },
            SymbolKind::Trait => {
                trimmed.contains("trait ") && trimmed.contains(symbol_name)
            },
            SymbolKind::Impl => {
                trimmed.contains("impl ") && trimmed.contains(symbol_name)
            },
            SymbolKind::Constant => {
                trimmed.contains("const ") && trimmed.contains(symbol_name)
            },
            SymbolKind::Static => {
                trimmed.contains("static ") && trimmed.contains(symbol_name)
            },
            _ => false,
        }
    }

    /// Extract symbols from Rust code using pattern matching
    /// In production, this would use tree-sitter queries for better accuracy
    fn extract_rust_symbols(&self, text: &str) -> Vec<(String, u32, SymbolKind)> {
        let mut symbols = Vec::new();

        for (line_num, line) in text.lines().enumerate() {
            let trimmed = line.trim();

            // Function definitions
            if let Some(fn_name) = self.extract_function_name(trimmed) {
                symbols.push((fn_name, line_num as u32 + 1, SymbolKind::Function));
            }

            // Struct definitions
            if let Some(struct_name) = self.extract_struct_name(trimmed) {
                symbols.push((struct_name, line_num as u32 + 1, SymbolKind::Struct));
            }

            // Enum definitions
            if let Some(enum_name) = self.extract_enum_name(trimmed) {
                symbols.push((enum_name, line_num as u32 + 1, SymbolKind::Enum));
            }

            // Trait definitions
            if let Some(trait_name) = self.extract_trait_name(trimmed) {
                symbols.push((trait_name, line_num as u32 + 1, SymbolKind::Trait));
            }

            // Impl blocks
            if let Some(impl_name) = self.extract_impl_name(trimmed) {
                symbols.push((impl_name, line_num as u32 + 1, SymbolKind::Impl));
            }

            // Constants
            if let Some(const_name) = self.extract_const_name(trimmed) {
                symbols.push((const_name, line_num as u32 + 1, SymbolKind::Constant));
            }

            // Static variables
            if let Some(static_name) = self.extract_static_name(trimmed) {
                symbols.push((static_name, line_num as u32 + 1, SymbolKind::Static));
            }
        }

        symbols
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

    fn extract_impl_name(&self, line: &str) -> Option<String> {
        if line.starts_with("impl ") {
            let after_impl = &line[5..];
            let impl_name = after_impl
                .split_whitespace()
                .next()?
                .trim_end_matches('{')
                .trim_end_matches('<');

            if self.is_valid_identifier(impl_name) {
                return Some(impl_name.to_string());
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

    fn extract_static_name(&self, line: &str) -> Option<String> {
        if line.contains("static ") {
            if let Some(static_start) = line.find("static ") {
                let after_static = &line[static_start + 7..];
                if let Some(colon_pos) = after_static.find(':') {
                    let static_name = after_static[..colon_pos].trim();
                    if self.is_valid_identifier(static_name) {
                        return Some(static_name.to_string());
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

    /// Generate codelens labels for symbols showing reference counts
    fn generate_codelens_labels(&self, text: &str) -> Vec<(u32, CodeLabel)> {
        let symbols = self.extract_rust_symbols(text);
        let mut labels = Vec::new();

        for (symbol_name, line_num, symbol_kind) in symbols {
            let references = self.find_references(text, &symbol_name, symbol_kind.clone());
            let ref_count = references.len();

            let label_text = self.format_reference_count(ref_count, &symbol_kind);

            let code_label = CodeLabel {
                spans: vec![CodeLabelSpan::literal(label_text, None)],
                filter_range: Range { start: 0, end: 0 },
                code: symbol_name.clone(),
            };

            labels.push((line_num, code_label));
        }

        labels
    }

    /// Format the reference count text based on count and symbol type
    fn format_reference_count(&self, count: usize, _symbol_kind: &SymbolKind) -> String {
        match count {
            0 => "0 references".to_string(),
            1 => "1 reference".to_string(),
            n => format!("{} references", n),
        }
    }

    /// Check if the extension should be active for the given language
    fn is_language_supported(&self, language: &str) -> bool {
        self.enabled_languages.contains(&language.to_lowercase())
    }

    /// Process a file and return codelens information
    pub fn process_file(&mut self, file_content: &str, file_path: &str, language: &str) -> Vec<(u32, CodeLabel)> {
        if !self.is_language_supported(language) {
            return Vec::new();
        }

        // Cache the results for this file
        let cache_key = format!("{}:{}", file_path, file_content.len());

        // For now, always regenerate (in production, we'd check if file changed)
        let labels = match language.to_lowercase().as_str() {
            "rust" => self.generate_codelens_labels(file_content),
            _ => Vec::new(), // Other languages not implemented yet
        };

        // Update cache
        let references: Vec<ReferenceInfo> = labels.iter().map(|(line, label)| {
            ReferenceInfo {
                symbol_name: label.code.clone(),
                file_path: file_path.to_string(),
                line: *line,
                column: 1,
                symbol_kind: SymbolKind::Function, // Default for now
            }
        }).collect();

        self.cached_references.insert(cache_key, references);

        labels
    }
}

zed::register_extension!(CodelensExtension);
