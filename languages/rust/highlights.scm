; Function definitions
(function_item
  name: (identifier) @function.definition)

; Function calls
(call_expression
  function: (identifier) @function.call)

; Struct definitions
(struct_item
  name: (type_identifier) @type.definition)

; Impl blocks
(impl_item
  type: (type_identifier) @type.impl)

; Type references
(type_identifier) @type.reference

; Method calls
(call_expression
  function: (field_expression
    field: (field_identifier) @method.call))

; Method definitions
(function_item
  name: (identifier) @method.definition
  (#match? @method.definition "^[a-z_]"))

; Constants
(const_item
  name: (identifier) @constant.definition)

; Static variables
(static_item
  name: (identifier) @variable.static.definition)

; Let bindings
(let_declaration
  pattern: (identifier) @variable.definition)

; Parameters
(parameter
  pattern: (identifier) @variable.parameter)

; Identifiers (general references)
(identifier) @identifier

; Macro calls
(macro_invocation
  macro: (identifier) @macro.call)

; Macro definitions
(macro_definition
  name: (identifier) @macro.definition)
