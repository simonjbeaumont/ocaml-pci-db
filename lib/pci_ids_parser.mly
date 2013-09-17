%{
open Printf
%}

%token <string> STRING
%token <int64> INT
%token COMMENT CLASS_DELIM TAB SPACE NEWLINE EOF

%start file
%type <unit> file

%%

file:
	| EOF { }
	| NEWLINE file { }
	| COMMENT file { }
	| vendors file { }

vendors:
	| vendor_def NEWLINE vendors { print_endline $1 }
	| devices { }

vendor_def:
	| INT SPACE SPACE name_str
		{ Printf.sprintf "Vendor: %04Lx %s" $1 $4 }

devices:
	| /* empty */ { }
	| device_def NEWLINE devices { print_endline $1 }
	| subdevice { }

device_def:
	| TAB INT SPACE SPACE name_str
		{ Printf.sprintf "Device: %04Lx %s" $2 $5 }

subdevice:
	| subdevice_def NEWLINE { print_endline $1 }

subdevice_def:
	| TAB TAB INT INT SPACE SPACE name_str
		{ Printf.sprintf "Subdevice: %04Lx %04Lx %s" $3 $4 $7 }

classes:
	| class_def NEWLINE classes { print_endline $1 }
	| subclasses { }

class_def:
	| CLASS_DELIM SPACE INT SPACE SPACE name_str
		{ Printf.sprintf "Class: %02Lx %s" $3 $6 }

subclasses:
	| /* empty */ { }
	| subclass_def NEWLINE subclasses { print_endline $1 }
	| progif { }

subclass_def:
	| TAB INT SPACE SPACE name_str
		{ Printf.sprintf "Subclass: %02Lx %s" $2 $5 }

progif:
	| progif_def NEWLINE { print_endline $1 }

progif_def:
	| TAB TAB INT SPACE SPACE name_str
		{ Printf.sprintf "Prog-if: %02Lx %s" $3 $6 }

name_str:
	| name_str SPACE name_str { Printf.sprintf "%s %s" $1 $3 }
	| STRING { $1 }
	| INT { Int64.to_string $1 }
