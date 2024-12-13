module Jamal :
  sig
    type token
    type term
    type env
    val tokenize : char list -> token list
    val parse_single : token list -> term * token list
    val parse : token list -> term
    val eval_in_env : env -> term -> term
    val eval : term -> term
    val pretty : term -> char list
    val interpreter : char list -> char list
    val interpreter_string : string -> string
  end