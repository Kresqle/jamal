module Context = Map.Make (String)

type expr =
    | Variable of string
    | Abstraction of { param : string ; body: expr }
    | Application of { func : expr ; arg : expr }

type value =
    | Closure of { context : value Context.t ; param : string ; body : expr }
    | Native of (value -> value)

let rec interpreter (context) expr = match expr with
| Variable name -> Context.find name context
| Abstraction { param ; body } -> Closure { context ; param ; body }
| Application { func ; arg } -> (
        let argument = interpreter context arg in
        match interpreter context func with
        | Closure { context ; param ; body } ->
                        interpreter (Context.add param argument context) body
        | Native f -> f argument
)

