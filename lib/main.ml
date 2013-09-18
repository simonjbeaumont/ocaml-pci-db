let string_of_token = function
	| Pci_ids_parser.CLASS x -> Printf.sprintf "CLASS: %02Lx %s" (fst x) (snd x)
	| Pci_ids_parser.SUBCLASS x -> Printf.sprintf "\tSUBCLASS: %02Lx %s" (fst x) (snd x)
	| Pci_ids_parser.PROGIF x -> Printf.sprintf "\t\tPROGIF: %02Lx %s" (fst x) (snd x)
	| Pci_ids_parser.EOF -> "EOF"

let string_of_foo x = Printf.sprintf "%02Lx %s" (fst x) (snd x)
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
