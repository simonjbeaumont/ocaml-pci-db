{
	open Pci_db_types
	open Pci_ids_parser
	let ioh = fun s -> Scanf.sscanf s "%Lx" (fun x -> x)
	let hex_str_of_int = fun x -> Printf.sprintf "0x%Lx" x
	let section = ref None
}

let hex  = ['0'-'9' 'a'-'f' 'A'-'F']+
let text = [^'\n']+

rule token = parse
	(* Ignore comments and newlines *)
	| '#'[^'\n']*'\n' { token lexbuf }
	| '\n' { token lexbuf }
	(* Class definitions *)
	| "C "(hex as id)"  "(text as name)'\n'
		{ section := Some `classes; CLASS (ioh id, name) }
	(* Vendor definitions *)
	| (hex as id)"  "(text as name)'\n'
		{ section := Some `vendors; VENDOR (ioh id, name) }
	(* Either device or subclass definitions depending on section *)
	| '\t'(hex as id)"  "(text as name)'\n'
		{
			match !section with
			| Some `classes -> SUBCLASS (ioh id, name)
			| Some `vendors -> DEVICE (ioh id, name)
			| None -> failwith "Lex error"
		}
	(* Prog-if definitions *)
	| '\t''\t'(hex as id)"  "(text as name)'\n'
		{ PROGIF (ioh id, name) }
	(* Subdevice definitions *)
	| '\t''\t'(hex as sv_id)" "(hex as sd_id)"  "(text as name)'\n'
		{ SUBDEVICE ((ioh sv_id, ioh sd_id), name) }
	(* End of useful content *)
	| eof { EOF }

