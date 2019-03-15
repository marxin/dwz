CFLAGS = -O2 -g
DWZ_VERSION := $(shell cat VERSION)
override CFLAGS += -Wall -W -D_FILE_OFFSET_BITS=64 -DDWZ_VERSION='"$(DWZ_VERSION)"'
prefix = /usr
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
mandir = $(datarootdir)/man
OBJECTS = dwz.o hashtab.o sha1.o dwarfnames.o
dwz: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ -lelf
install: dwz
	install -D dwz $(DESTDIR)$(bindir)/dwz
	install -D -m 644 dwz.1 $(DESTDIR)$(mandir)/man1/dwz.1
clean:
	rm -f $(OBJECTS) *~ core* dwz

PWD:=$(shell pwd -P)

TEST_EXECS = hello

hello:
	$(CC) hello.c -o $@ -g

check: dwz $(TEST_EXECS)
	mkdir -p testsuite-bin
	cd testsuite-bin; ln -sf $(PWD)/dwz .
	export PATH=$(PWD)/testsuite-bin:$$PATH; export LC_ALL=C; \
	runtest --tool=dwz -srcdir testsuite $(RUNTESTFLAGS)
	rm -Rf testsuite-bin $(TEST_EXECS)
