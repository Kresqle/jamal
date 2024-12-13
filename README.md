# jamal

Hopefully a future language. For the moment, it only is a lambda calculus interpreter in OCaml

## Examples

### 1. Lambda calculus

This example can be found (here)[./examples/lambda_calculus.ml].

`examples/lambda_calculus.ml`
```
let _ = print_endline (interpreter_string "\\x.x") (* prints : "\x.x" *)
let _ = print_endline (interpreter_string "(\\x.x   \\y.y)");; (* prints : "\y.y" *)
let _ = print_endline (interpreter_string "(\\x.x   \\y.y)");; (* prints : "\y.y" *)
let _ = print_endline (interpreter_string "((\\x.\\y.x   \\a.(a a))        \\b.b)");; (* prints : "\\a.(a a)" *)
```

To run the file directly, hence this project does not use dune, you would need to compile the code in a way that ensures every files communicate properly :

```
ocamlc -c jamal.mli
ocamlc -c jamal.ml
ocamlc -I . -o lambda_calculus.out jamal.cmo examples/lambda_calculus.ml
```

Running `./lambda_calculus.out` would print :

```
\x.x
\y.y
\y.y
\a.(a a)
```