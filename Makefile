.PHONY: install uninstall clean

dist/build/lib-pci_db/pci_db.cmxa:
	obuild configure
	obuild build

install:
	ocamlfind install pci-db lib/META \
		$(wildcard dist/build/lib-pci_db/*)

uninstall:
	ocamlfind remove pci-db

clean:
	rm -rf dist
