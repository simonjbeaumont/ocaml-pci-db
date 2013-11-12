ocaml-pci-db
============

Library to parse and query the pci.ids database of PCI devices.

Build dependencies
------------------

* [OUnit](http://ounit.forge.ocamlcore.org/)

Installation
------------
This is intended to be an OPAM package but for now it can be insalled like
this:
```
$ make
$ make install
```

Unit tests can be run using:
```
$ make test
```

Usage
-----

Simple module which uses `Pci_db` to find PCI device information:

```ocaml
let () =
  let pci_db = Pci_db.of_file Pci_db.pci_ids_path in
  let open Pci_db_types.Id in
  let class_name = Pci_db.get_class_name pci_db (CLASS_ID 0x03L) in
  let vendor_name = Pci_db.get_vendor_name pci_db (VENDOR_ID 0x10deL) in
  let device_name = Pci_db.get_device_name pci_db (VENDOR_ID 0x10deL) (DEVICE_ID 0x01daL) in
  Printf.printf "The %s is a %s and is made by %s.\n"
    device_name class_name vendor_name
```

Compile and run as follows:

```
$ ocamlfind ocamlopt -package unix -package pci-db -thread -linkpkg trial.ml -o trial
$ ./trial
The 'G72M [Quadro NVS 110M]' is a 'Display controller' and is made by 'NVIDIA Corporation'.
```

It's also possible to use this library in scripts using the following:

```ocaml
#!/path/to/ocaml

#use "topfind"
#require "pci-db"
```
