let _ =
	let path = Sys.argv.(1) in
	let pci_db = Pci_db.of_file path in
	Pci_db.print pci_db
