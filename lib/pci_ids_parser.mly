%{
open Pci_db_types
%}

%token <Pci_db_types.id * string> CLASS SUBCLASS PROGIF VENDOR DEVICE SUBDEVICE
%token EOF

%start file
%type <Pci_db_types.t> file

%%

file:
	| EOF { { classes = IdMap.empty; vendors = IdMap.empty } }
	| classes file { { $2 with classes = $1 } }
	| vendors file { { $2 with vendors = $1 } }
	;

/* Parsing for the classes section of the pci.ids file */
classes:
	| { IdMap.empty }
	| classs classes { IdMap.add (fst $1) (snd $1) $2 }
	;
classs:
	| CLASS subclasses { (fst $1), { c_name = (snd $1); subclasses = $2 } }
subclasses:
	| { IdMap.empty }
	| subclass subclasses { IdMap.add (fst $1) (snd $1) $2 }
	;
subclass:
	| SUBCLASS progifs { (fst $1), { sc_name = (snd $1); progifs = $2 } }
	;
progifs:
	| { IdMap.empty }
	| progif progifs { IdMap.add (fst $1) (snd $1) $2 }
	;
progif:
	| PROGIF { (fst $1), { pi_name = (snd $1); } }
	;

/* Parsing for the vendors and devices section of the pci.ids file */
vendors:
	| { IdMap.empty }
	| vendor vendors { IdMap.add (fst $1) (snd $1) $2 }
	;
vendor:
	| VENDOR devices { (fst $1), { v_name = (snd $1); devices = $2 } }
devices:
	| { IdMap.empty }
	| device devices { IdMap.add (fst $1) (snd $1) $2 }
	;
device:
	| DEVICE subdevices { (fst $1), { d_name = (snd $1); subdevices = $2 }}
	;
subdevices:
	| { IdMap.empty }
	| subdevice subdevices { IdMap.add (fst $1) (snd $1) $2 }
	;
subdevice:
	| SUBDEVICE { (fst $1), { sd_name = (snd $1) } }
	;
