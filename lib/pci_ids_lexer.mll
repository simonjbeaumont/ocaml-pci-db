{
	open Pci_db_types.Id
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
		{ section := Some `classes; CLASS (CLASS_ID (ioh id), name) }
	(* Vendor definitions *)
	| (hex as id)"  "(text as name)'\n'
		{ section := Some `vendors; VENDOR (VENDOR_ID (ioh id), name) }
	(* Either device or subclass definitions depending on section *)
	| '\t'(hex as id)"  "(text as name)'\n'
		{
			match !section with
			| Some `classes -> SUBCLASS (SUBCLASS_ID (ioh id), name)
			| Some `vendors -> DEVICE (DEVICE_ID (ioh id), name)
			| None -> failwith "Lex error"
		}
	(* Prog-if definitions *)
	| '\t''\t'(hex as id)"  "(text as name)'\n'
		{ PROGIF (PROGIF_ID (ioh id), name) }
	(* Subdevice definitions *)
	| '\t''\t'(hex as sv_id)" "(hex as sd_id)"  "(text as name)'\n'
		{ SUBDEVICE (SUBDEVICE_ID (ioh sv_id, ioh sd_id), name) }
	(* End of useful content *)
	| eof { EOF }

