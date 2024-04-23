(identifier) @variable

(call_expression
  function: (identifier) @function)

(call_expression
  function: (identifier) @function.builtin
  (#match? @function.builtin "^(int|float|string|len|del|print|append|set|slice|argv|open|close|read|readline|write)$"))

(function_definition
  name: (identifier) @function)

(comment) @comment

[
 "fn"
 "return"
 "let"
 "while"
 "for"
 "if"
 "else"
 "break"
 "continue"
] @keyword

[
 "-"
 "+"
 "*"
 "/"
 "!"
 "="
 ":="
 "<"
 "<="
 ">"
 ">="
 "=="
 "!="
] @operator

[
 (integer)
 (float)
] @number

(string_literal) @string

[
 (true)
 (false)
] @constant.builtin
