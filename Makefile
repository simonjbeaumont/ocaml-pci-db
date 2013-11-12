.PHONY: install uninstall clean test

dist: lib/*.ml* lib_test/*.ml
	obuild configure --enable-tests
	obuild build

install:
	ocamlfind install pci-db lib/META \
		$(wildcard dist/build/lib-pci_db/*)

uninstall:
	ocamlfind remove pci-db

clean:
	rm -rf dist

test: dist
	obuild test --output
