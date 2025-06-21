use zed_extension_api as zed;

struct CodelensExtension;

impl zed::Extension for CodelensExtension {
    fn new() -> Self {
        Self
    }
}

zed::register_extension!(CodelensExtension);
