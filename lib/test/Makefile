OCAMLCFLAGS+=-g -I ..
OCAMLC = ocamlc $(OCAMLCFLAGS)

.PHONY: build
build:
	$(OCAMLC) -c ../pci_db_types.ml
	ocamlyacc ../pci_ids_parser.mly
	$(OCAMLC) -c ../pci_ids_parser.mli
	ocamllex ../pci_ids_lexer.mll
	$(OCAMLC) -c ../pci_ids_lexer.ml
	$(OCAMLC) -c ../pci_ids_parser.ml
	$(OCAMLC) -c ../pci_db.mli ../pci_db.ml
	$(OCAMLC) -c print_db.ml
	$(OCAMLC) -o print_db ../pci_db_types.cmo ../pci_ids_lexer.cmo ../pci_ids_parser.cmo ../pci_db.cmo print_db.cmo
	rm ../pci_ids_lexer.ml ../pci_ids_parser.mli ../pci_ids_parser.ml

.PHONY: clean
clean:
	rm print_db ../*.cmo ../*.cmi *.cmo *.cmi
