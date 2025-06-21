; Function definitions for symbol extraction
(function_item
  name: (identifier) @symbol.function
  (#set! symbol.kind "function"))

; Struct definitions
(struct_item
  name: (type_identifier) @symbol.struct
  (#set! symbol.kind "struct"))

; Enum definitions
(enum_item
  name: (type_identifier) @symbol.enum
  (#set! symbol.kind "enum"))

; Trait definitions
(trait_item
  name: (type_identifier) @symbol.trait
  (#set! symbol.kind "trait"))

; Impl blocks
(impl_item
  type: (type_identifier) @symbol.impl
  (#set! symbol.kind "impl"))

; Module definitions
(mod_item
  name: (identifier) @symbol.module
  (#set! symbol.kind "module"))

; Constant definitions
(const_item
  name: (identifier) @symbol.constant
  (#set! symbol.kind "constant"))

; Static variable definitions
(static_item
  name: (identifier) @symbol.static
  (#set! symbol.kind "static"))

; Type alias definitions
(type_item
  name: (type_identifier) @symbol.type_alias
  (#set! symbol.kind "type_alias"))

; Macro definitions
(macro_definition
  name: (identifier) @symbol.macro
  (#set! symbol.kind "macro"))
