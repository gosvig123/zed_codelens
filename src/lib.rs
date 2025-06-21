use zed_extension_api::{self as zed, Result, LanguageServerId, Worktree};
use serde_json::Value;

struct CodelensExtension;

impl zed::Extension for CodelensExtension {
    fn new() -> Self {
        Self
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
    // This is a minimal implementation for demonstration
    // The actual CodeLens functionality would be implemented here
    // when Zed's extension API supports it
}

zed::register_extension!(CodelensExtension);
