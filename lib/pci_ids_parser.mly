%{
open Printf
let string_of_foo x = Printf.sprintf "%02Lx %s" (fst x) (snd x)
%}

%token <int64 * string> CLASS SUBCLASS PROGIF
%token EOF

%start file
%type <unit> file

%%

file:
	| EOF { }
	| classes file { }
	;
classes:
	| { [] }
	| classs classes { $1 :: $2 }
	;
classs:
	| CLASS subclasses { Printf.printf "%s\n%s" (string_of_foo $1) (String.concat "" $2) }
subclasses:
	| { [] }
	| subclass subclasses { $1 :: $2 }
	;
subclass:
	| SUBCLASS progifs { Printf.sprintf "\t%s\n%s" (string_of_foo $1) (String.concat "" $2) }
	;
progifs:
	| { [] }
	| progif progifs { $1 :: $2 }
	;
progif:
	| PROGIF { Printf.sprintf "\t\t%s\n" (string_of_foo $1) }
	;

