{
	open Pci_ids_parser
	let int_of_hex_str = fun s -> Scanf.sscanf s "%Lx" (fun x -> x)
	let hex_str_of_int = fun x -> Printf.sprintf "0x%Lx" x
}

let hex  = [ '0'-'9' 'a'-'f' 'A'-'F' ]+
let name = [^ ' ' '\t' '\n' ]+

rule token = parse
	(* Ignore comments *)
	| '#'[^'\n']*'\n' { COMMENT }
	(* Newlines *)
	| '\n' { NEWLINE }
	(* This file uses semantic whitespace *)
	| '\t' { TAB }
	| ' ' { SPACE }
	(* Class lines start with a 'C' *)
	| 'C' { CLASS_DELIM }
	| hex as x { INT (int_of_hex_str x) }
	| name as x { STRING x }
	| eof { raise End_of_file }

{
	(* let string_of_token = function *)
		(* | COMMENT -> "COMMENT" *)
		(* | NEWLINE -> "NEWLINE" *)
		(* | TAB -> "TAB" *)
		(* | SPACE -> "SPACE" *)
		(* | CLASS_DELIM -> "_CD_" *)
		(* | INT x -> "INT (" ^ hex_str_of_int x ^ ")" *)
		(* | STRING x -> "STRING (" ^ x ^ ")" *)
		(* | EOF -> "\\EOF" *)

	(* let rec parse lexbuf = *)
		(* let token = token lexbuf in *)
		(* print_endline (string_of_token token); *)
		(* parse lexbuf *)

	(* let main () = *)
		(* let cin = *)
		(* if Array.length Sys.argv > 1 *)
		(* then open_in Sys.argv.(1) *)
		(* else stdin *)
		(* in *)
		(* let lexbuf = Lexing.from_channel cin in *)
		(* try parse lexbuf *)
		(* with End_of_file -> () *)

	(* let _ = Printexc.print main () *)
}
