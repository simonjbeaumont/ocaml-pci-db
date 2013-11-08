open OUnit

let skip_test_print = true

let rec foldi n f acc =
	if n = 0 then acc else foldi (pred n) f (f acc)

let test_db =
	let open Filename in
	String.concat dir_sep
		[ (foldi 4 dirname Sys.executable_name); "lib_test"; "mock-pci.ids" ]

let with_test_db (f: Pci_db.t -> unit) =
	let pci_db = Pci_db.of_file test_db in
	f pci_db

let test_of_file _ =
	with_test_db (fun _ -> ())

let test_print _ =
	skip_if skip_test_print "test_print";
	with_test_db (fun db ->
		Pci_db.print db
	)

let _ =
	let suite = "pci_db" >:::
		[
			"test_of_file" >:: test_of_file;
			"test_print" >:: test_print;
		]
	in
	run_test_tt ~verbose:true suite
