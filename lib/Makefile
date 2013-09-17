OCAMLCFLAGS+=-g
OCAMLC = ocamlc $(OCAMLCFLAGS)

.PHONY: build
build:
	ocamlyacc pci_ids_parser.mly
	$(OCAMLC) -c pci_ids_parser.mli
	ocamllex pci_ids_lexer.mll
	$(OCAMLC) -c pci_ids_lexer.ml
	$(OCAMLC) -c pci_ids_parser.ml
	$(OCAMLC) -c main.ml
	$(OCAMLC) -o parse pci_ids_lexer.cmo pci_ids_parser.cmo main.cmo
	rm pci_ids_lexer.ml pci_ids_parser.mli pci_ids_parser.ml

.PHONY: clean
clean:
	rm parse *.cmo *.cmi
