open OUnit

let with_test_db (f: Pci_db.t -> unit) =
	let pci_db = Pci_db.of_file "/usr/share/hwdata/pci.ids" in
	f pci_db

let test_of_file _ =
	with_test_db (fun _ -> ())

let _ =
	let suite = "pci_db" >:::
		[
			"test_of_file" >:: test_of_file;
		]
	in
	run_test_tt ~verbose:true suite
