type token = LParen | RParen | Lambda | Dot | Variable of char

type term =
  | VariableT of char
  | LambdaT of char * term
  | ClosureT of char * term * env
  | ApplicationT of term * term

and env = (char * term) list
    
let alphabet = "abcdefghijklmnopqrstuvwxyz" |> String.to_seq |> List.of_seq

let rec tokenize text =
  match text with
  | [] -> []
  | '(' :: rest -> LParen :: tokenize rest
  | ')' :: rest -> RParen :: tokenize rest
  | '\\' :: rest -> Lambda :: tokenize rest
  | '.' :: rest -> Dot :: tokenize rest
  | c :: rest ->
      (if List.mem c alphabet then [ Variable c ] else []) @ tokenize rest

let rec parse_single tokens =
  match tokens with
  | Variable name :: rest -> (VariableT name, rest)
  | Lambda :: Variable arg :: Dot :: body_code ->
      let body, rest = parse_single body_code in
      (LambdaT (arg, body), rest)
  | LParen :: code -> (
      let fn, after_first = parse_single code in
      let value, after_value = parse_single after_first in
      match after_value with
      | RParen :: rest -> (ApplicationT (fn, value), rest)
      | _ -> failwith "Expected ')'")
  | _ -> failwith "Error while parsing"

let parse tokens = parse_single tokens |> fst


let rec eval_in_env env term =
  match term with
  | VariableT name -> (
    match List.find_opt (fun (a_name, term) -> a_name = name) env with
    | Some (_, term) -> term
    | None -> failwith "Couldn't find a term"
    )
  | LambdaT (arg, body) ->
    ClosureT (arg, body, env)
  | ApplicationT (fn, value) -> (
    match eval_in_env env fn with
    | ClosureT (arg, body, closed_env) ->
      let evaluated_value = eval_in_env env value in
      let new_env = (arg, evaluated_value) :: closed_env @ env in
      eval_in_env new_env body
    | _ -> failwith "Cannot apply something given"
    )
  | closure -> closure

let eval term = eval_in_env [] term

let rec pretty term =
  match term with
  | VariableT name -> [ name ]
  | LambdaT (arg, body) -> [ '\\' ; arg ; '.' ] @ pretty body
  | ClosureT (arg, body, _) -> [ '\\' ; arg ; '.' ] @ pretty body
  | ApplicationT (fn, value) -> '(' :: pretty fn @ [ ' ' ] @ pretty value @ [ ')' ]

let interpreter characters =
  characters
  |> tokenize
  |> parse
  |> eval
  |> pretty

let interpreter_string string =
  string
  |> String.to_seq
  |> List.of_seq
  |> interpreter
  |> List.map (String.make 1)
  |> String.concat ""