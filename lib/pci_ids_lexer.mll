{
	open Pci_ids_parser
	let int_of_hex_str = fun s -> Scanf.sscanf s "%Lx" (fun x -> x)
	let hex_str_of_int = fun x -> Printf.sprintf "0x%Lx" x
}

let hex  = ['0'-'9' 'a'-'f' 'A'-'F']+
let text = [^'\n']+

rule token = parse
	(* Ignore comments and newlines *)
	| '#'[^'\n']*'\n' { token lexbuf }
	| '\n' { token lexbuf }
	(* The useful content *)
	| "C "(hex as id)"  "(text as name)'\n'     { CLASS    (int_of_hex_str id, name) }
	| '\t'(hex as id)"  "(text as name)'\n'     { SUBCLASS (int_of_hex_str id, name) }
	| '\t''\t'(hex as id)"  "(text as name)'\n' { PROGIF   (int_of_hex_str id, name) }
	(* End of useful content *)
	| eof { raise End_of_file }

