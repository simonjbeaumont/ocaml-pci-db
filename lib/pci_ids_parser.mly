%{
let string_of_token = function
	| CLASS (id, name) -> Printf.sprintf "%02Lx %s" id name
	| SUBCLASS (id, name) -> Printf.sprintf "%02Lx %s" id name
	| PROGIF (id, name) -> Printf.sprintf "%02Lx %s" id name
	| VENDOR (id, name) -> Printf.sprintf "%02Lx %s" id name
	| DEVICE (id, name) -> Printf.sprintf "%02Lx %s" id name
	| SUBDEVICE ((sv_id, sd_id), name) -> Printf.sprintf "%04Lx %04Lx %s" sv_id sd_id name
	| _ -> failwith "Use other printer"


%}

%token <int64 * string> CLASS SUBCLASS PROGIF VENDOR DEVICE
%token <(int64 * int64) * string> SUBDEVICE
%token EOF

%start file
%type <unit> file

%%

file:
	| EOF { }
	| classes file { }
	| vendors file { }
	;

/* Parsing for the classes section of the pci.ids file */
classes:
	| { [] }
	| classs classes { $1 :: $2 }
	;
classs:
	| CLASS subclasses { Printf.printf "%s\n%s" (string_of_token (CLASS $1)) (String.concat "" $2) }
subclasses:
	| { [] }
	| subclass subclasses { $1 :: $2 }
	;
subclass:
	| SUBCLASS progifs { Printf.sprintf "\t%s\n%s" (string_of_token (SUBCLASS $1)) (String.concat "" $2) }
	;
progifs:
	| { [] }
	| progif progifs { $1 :: $2 }
	;
progif:
	| PROGIF { Printf.sprintf "\t\t%s\n" (string_of_token (PROGIF $1)) }
	;

/* Parsing for the vendors and devices section of the pci.ids file */
vendors:
	| { [] }
	| vendor vendors { $1 :: $2 }
	;
vendor:
	| VENDOR devices { Printf.printf "%s\n%s" (string_of_token (VENDOR $1)) (String.concat "" $2) }
devices:
	| { [] }
	| device devices { $1 :: $2 }
	;
device:
	| DEVICE subdevices { Printf.sprintf "\t%s\n%s" (string_of_token (DEVICE $1)) (String.concat "" $2) }
	;
subdevices:
	| { [] }
	| subdevice subdevices { $1 :: $2 }
	;
subdevice:
	| SUBDEVICE { Printf.sprintf "\t\t%s\n" (string_of_token (SUBDEVICE $1)) }
	;
