let string_of_token = function
	| Pci_ids_parser.CLASS (id, name) -> Printf.sprintf "CLASS: %02Lx %s" id name
	| Pci_ids_parser.SUBCLASS (id, name) -> Printf.sprintf "SUBCLASS: %02Lx %s" id name
	| Pci_ids_parser.PROGIF (id, name) -> Printf.sprintf "PROGIF: %02Lx %s" id name
	| Pci_ids_parser.VENDOR (id, name) -> Printf.sprintf "VENDOR: %04Lx %s" id name
	| Pci_ids_parser.DEVICE (id, name) -> Printf.sprintf "DEVICE: %04Lx %s" id name
	| Pci_ids_parser.SUBDEVICE ((sv_id, sd_id), name) -> Printf.sprintf "SUBDEVICE: %04Lx %04Lx %s" sv_id sd_id name
	| _ -> failwith "Use other printer"

let string_of_foo x = Printf.sprintf "%02Lx %s" (fst x) (snd x)
let main () =
	let cin =
	if Array.length Sys.argv > 1
	then open_in Sys.argv.(1)
	else stdin
	in
	try
		let lexbuf = Lexing.from_channel cin in
		while true do
			print_endline (string_of_token (Pci_ids_lexer.token lexbuf))
		done
		(* Pci_ids_parser.file Pci_ids_lexer.token lexbuf *)
	with End_of_file -> ()

let _ = Printexc.record_backtrace true

let _ = Printexc.print main ()
