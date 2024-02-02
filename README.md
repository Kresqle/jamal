# jamal

Hopefully a future language. For the moment, it only is a lambda calculus interpreter in OCaml

## Examples

### Hello world

```ocaml
#use "jamal.ml"

let f = Abstraction {
  param = "f";
  body = Application {
    func = Variable "print_hello_world";
    arg = Variable "print_hello_world"
  }
}

let code = Application { func = f ; arg = f }

let initial_context =
  Context.empty
  |> Context.add "print_hello_world" (Native
    (fun v -> print_endline "hello world";
    v))

let _ = interpreter initial_context code
```
