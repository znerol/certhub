ifeq ($(prefix),)
    prefix := /usr/local
endif
ifeq ($(exec_prefix),)
    exec_prefix := $(prefix)
endif
ifeq ($(bindir),)
    bindir := $(exec_prefix)/bin
endif
ifeq ($(datarootdir),)
    datarootdir := $(prefix)/share
endif
ifeq ($(mandir),)
    mandir := $(datarootdir)/man
endif
ifeq ($(python),)
    python := python
endif

all: bin test doc

%.1 : %.1.md
	pandoc -s -t man $< -o $@

bin:
	# empty for now

lint: bin
	shellcheck bin/certhub-import-csr
	shellcheck bin/certhub-run-certbot

test: bin
	PATH="$(shell pwd)/bin:${PATH}" $(python) -m test

doc: \
	doc/certhub-import-csr.1 \
	doc/certhub-run-certbot.1

clean:
	-rm doc/certhub-import-csr.1
	-rm doc/certhub-run-certbot.1
	-rm -rf dist
	-rm -rf build

install-doc: doc
	install -m 0644 -D doc/certhub-import-csr.1 $(DESTDIR)$(mandir)/man1/certhub-import-csr.1
	install -m 0644 -D doc/certhub-run-certbot.1 $(DESTDIR)$(mandir)/man1/certhub-run-certbot.1

install-bin: bin
	install -m 0755 -D bin/certhub-import-csr $(DESTDIR)$(bindir)/certhub-import-csr
	install -m 0755 -D bin/certhub-run-certbot $(DESTDIR)$(bindir)/certhub-run-certbot

install: install-bin install-doc

uninstall:
	-rm -f $(DESTDIR)$(bindir)/certhub-import-csr
	-rm -f $(DESTDIR)$(bindir)/certhub-run-certbot
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-import-csr.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-run-certbot.1

dist-bin:
	-rm -rf build
	make DESTDIR=build prefix=/ install
	mkdir -p dist
	tar --owner=root:0 --group=root:0 -czf dist/certhub-dist.tar.gz -C build .

dist-src:
	mkdir -p dist
	git archive -o dist/certhub-src.tar.gz HEAD

dist: dist-src dist-bin

.PHONY: \
	all \
	clean \
	dist \
	dist-bin \
	dist-src \
	install \
	install-bin \
	install-doc \
	lint \
	test \
	uninstall \
