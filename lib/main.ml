let of_ic path =
	let ic = open_in "/usr/share/hwdata/pci.ids" in
	let lexbuf = Lexing.from_channel ic in
	Pci_ids_parser.file Pci_ids_lexer.token lexbuf

let main () =
	let cin =
	if Array.length Sys.argv > 1
	then open_in Sys.argv.(1)
	else stdin
	in
	(* try *)
		let lexbuf = Lexing.from_channel cin in
		(* while true do *)
			(* print_endline (string_of_token (Pci_ids_lexer.token lexbuf)) *)
		(* done *)
		Pci_ids_parser.file Pci_ids_lexer.token lexbuf
	(* with End_of_file -> { Pci_db_types.classes = Pci_db_types.IdMap.empty; Pci_db_types.vendors = Pci_db_types.IdMap.empty } *)

let _ = Printexc.record_backtrace true

let _ = Printexc.print main ()
