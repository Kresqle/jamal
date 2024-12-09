# jamal

Hopefully a future language. For the moment, it only is a lambda calculus interpreter in OCaml

## Examples

### Hello world

```ocaml
#use "jamal.ml"

let _ = print_endline (interpreter_string "\\x.x") (* prints : "\x.x" *)
let _ = print_endline (interpreter_string "(\\x.x   \\y.y)");; (* prints : "\y.y" *)
let _ = print_endline (interpreter_string "(\\x.x   \\y.y)");; (* prints : "\y.y" *)
let _ = print_endline (interpreter_string "((\\x.\\y.x   \\a.(a a))        \\b.b)");; (* prints : "\\a.(a a)" *)
```
