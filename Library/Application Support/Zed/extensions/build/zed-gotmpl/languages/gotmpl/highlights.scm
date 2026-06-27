(identifier) @variable

(field_identifier) @variable.member

(function_call
  function: (identifier) @function)

[
  "."
] @punctuation.delimiter

[
  "("
  ")"
] @punctuation.bracket

[
    "{{"
    "}}"
    "{{-"
    "-}}"
] @punctuation.special

[
    "block"
    ; "break"
    ; "continue"
    "define"
    "else"
    "end"
    "if"
    "range"
    "template"
    "with"
] @keyword

[
    ":="
    ; "eq"
    ; "ge"
    ; "gt"
    ; "le"
    ; "lt"
    ; "ne"
] @operator

[
  (interpreted_string_literal)
  (raw_string_literal)
  (rune_literal)
] @string

(escape_sequence) @string.escape

[
    (int_literal)
    (float_literal)
    (imaginary_literal)
] @number

[
    (true)
    (false)
] @boolean

[
  (nil)
] @constant.builtin

(comment) @comment
