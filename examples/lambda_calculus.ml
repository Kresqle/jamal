open Jamal

let _ = print_endline (Jamal.interpreter_string "\\x.x") (* prints : "\x.x" *)
let _ = print_endline (Jamal.interpreter_string "(\\x.x   \\y.y)");; (* prints : "\y.y" *)
let _ = print_endline (Jamal.interpreter_string "(\\x.x   \\y.y)");; (* prints : "\y.y" *)
let _ = print_endline (Jamal.interpreter_string "((\\x.\\y.x   \\a.(a a))        \\b.b)");; (* prints : "\\a.(a a)" *)