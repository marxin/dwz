CFLAGS = -O2 -g -march=native
DWZ_VERSION := $(shell cat VERSION)
override CFLAGS += -Wall -W -D_FILE_OFFSET_BITS=64 -DDWZ_VERSION='"$(DWZ_VERSION)"'
prefix = /usr
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
mandir = $(datarootdir)/man
OBJECTS = dwz.o hashtab.o sha1.o dwarfnames.o
dwz: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ -lelf $(CFLAGS)
install: dwz
	install -D dwz $(DESTDIR)$(bindir)/dwz
	install -D -m 644 dwz.1 $(DESTDIR)$(mandir)/man1/dwz.1
clean:
	rm -f $(OBJECTS) *~ core* dwz
distclean: clean
	rm -f *.gcda *.gcno

pgo:
	make distclean
	make dwz CFLAGS="$(CFLAGS) -fprofile-generate"
	./test.py --train
	make clean
	make dwz CFLAGS="$(CFLAGS) -fprofile-use"
