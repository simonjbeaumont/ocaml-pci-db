let string_of_token = function
	| Pci_ids_parser.CLASS_DELIM -> "CLASS_DELIM"
	| Pci_ids_parser.INT x -> "INT"
	| Pci_ids_parser.STRING x -> "STRING " ^ x
	| Pci_ids_parser.SPACE -> "SPACE"
	| Pci_ids_parser.TAB -> "TAB"
	| Pci_ids_parser.COMMENT -> "COMMENT"
	| Pci_ids_parser.NEWLINE -> "NEWLINE"
	| Pci_ids_parser.EOF -> "EOF"

let main () =
	let cin =
	if Array.length Sys.argv > 1
	then open_in Sys.argv.(1)
	else stdin
	in
	try
		let lexbuf = Lexing.from_channel cin in
		(* while true do *)
			(* print_endline (string_of_token (Pci_ids_lexer.token lexbuf)) *)
		(* done *)
		Pci_ids_parser.file Pci_ids_lexer.token lexbuf
	with End_of_file -> ()

let _ = Printexc.record_backtrace true

let _ = Printexc.print main ()
