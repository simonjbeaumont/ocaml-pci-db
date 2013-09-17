%{
open Printf
%}

%token <string> STRING
%token <int64> INT
%token COMMENT CLASS_DELIM TAB SPACE NEWLINE EOF

%start file /* the entry point */
%type <unit> file

%%

file:
	| EOF { }
	| NEWLINE file { }
	| COMMENT file { }
	| classes file { }

classes:
	| class_def NEWLINE classes { }
	| subclasses { }

class_def:
	| CLASS_DELIM SPACE INT SPACE SPACE name_str
		{ Printf.printf "Class: %02Lx %s\n" $3 $6 }

subclasses:
	| /* empty */ { }
	| subclass_def NEWLINE subclasses { }
	| progif { }

subclass_def:
	| TAB INT SPACE SPACE name_str
		{ Printf.printf "Subclass: %02Lx %s\n" $2 $5 }

progif:
	| progif_def NEWLINE { }

progif_def:
	| TAB TAB INT SPACE SPACE name_str
		{ Printf.printf "Prog-if: %02Lx %s\n" $3 $6 }

name_str:
	| name_str SPACE name_str { Printf.sprintf "%s %s" $1 $3 }
	| STRING { $1 }
	| INT { Int64.to_string $1 }
