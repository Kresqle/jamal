(** A type representing tokens in a lambda calculus expression. *)
type token =
  | LParen (** Left parenthesis '(' *)
  | RParen (** Right parenthesis *)
  | Lambda (** Lambda '\\' symbol *)
  | Dot (** Dot '.' symbol *)
  | Variable of char (** Variable represented by a single character *)

(** A type representing terms in lambda calculus. *)
type term =
  | VariableT of char (** A variable term. *)
  | LambdaT of char * term (** A lambda abstraction with an argument and a body. *)
  | ClosureT of char * term * env (** A closure term with an argument, body and environment. *)
  | ApplicationT of term * term (** An application of one term to another. *)

(** A type representing an environment, which is a list of variable bindings. *)
and env = (char * term) list

(** A list of valid variable characters in the alphabet. *)
let alphabet : char list = "abcdefghijklmnopqrstuvwxyz" |> String.to_seq |> List.of_seq

(**
  [tokenize text] converts a list of characters [text] into a list of tokens
  representing a lambda calculus expression. 
*)
let rec tokenize (text : char list) : token list =
  match text with
  | [] -> []
  | '(' :: rest -> LParen :: tokenize rest
  | ')' :: rest -> RParen :: tokenize rest
  | '\\' :: rest -> Lambda :: tokenize rest
  | '.' :: rest -> Dot :: tokenize rest
  | c :: rest ->
      (if List.mem c alphabet then [ Variable c ] else []) @ tokenize rest

(**
    [parse_single tokens] parses a single term from the list of tokens [tokens],
    returning the parsed term and the remaining tokens.
*)
let rec parse_single (tokens : token list) : term * token list =
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

(** [parse tokens] parses the entire list of tokens [tokens] into a term *)
let parse (tokens : token list) : term = parse_single tokens |> fst

(**
  [eval_in_env env term] evaluates a lambda calculus [term] within the given
  environment [env].
*)
let rec eval_in_env (env : env) (term : term) : term =
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

(** [eval term] evaluates a lambda calculus [term] in an empty environment. *)
let eval (term : term) : term = eval_in_env [] term

(**
  [pretty term] converts a lambda calculus [term] into a list of characters
  representing its string representation.
*)
let rec pretty (term : term) : char list =
  match term with
  | VariableT name -> [ name ]
  | LambdaT (arg, body) -> [ '\\' ; arg ; '.' ] @ pretty body
  | ClosureT (arg, body, _) -> [ '\\' ; arg ; '.' ] @ pretty body
  | ApplicationT (fn, value) -> '(' :: pretty fn @ [ ' ' ] @ pretty value @ [ ')' ]

(**
  [interpreter characters] processes a list of characters [characters] by
  tokenizing, parsing, evaluating, and pretty-printing them.
*)
let interpreter (characters : char list) : char list =
  characters
  |> tokenize
  |> parse
  |> eval
  |> pretty

(**
  [interpreter_string string_expr] processes a string [string_expr] by tokenizing,
  parsing, evaluating, and returning the result as a string.
*)
let interpreter_string (string_expr : string) : string =
  string_expr
  |> String.to_seq
  |> List.of_seq
  |> interpreter
  |> List.map (String.make 1)
  |> String.concat ""