
include settings.mk
LIBDIR = $(PREFIX)/lib/gtk-pascal-gen/0.9
VARDIR = $(VARPREFIX)/lib/gtk-pascal-gen/0.9
#/usr/var)
BINDIR = $(PREFIX)/bin

all: gtk-pascal-gen

gtk-pascal-gen: gtk-pascal-gen.in
	sed -e 's;XXXVARDIRXXX;'$(VARDIR)';' gtk-pascal-gen.in >gtk-pascal-gen || rm -f gtk-pascal-gen
 
install: gtk-pascal-gen
	install -m 755 -d $(DESTDIR)$(LIBDIR)
	install -m 755 -d $(DESTDIR)$(LIBDIR)/app
	install -m 755 -d $(DESTDIR)$(VARDIR)
	install -m 755 -d $(DESTDIR)$(VARDIR)/templates
	install -m 755 -d $(DESTDIR)$(VARDIR)/templates/delphi
	
	if [ ! -f "$(DESTDIR)$(VARDIR)/ids.txt" ] ; then install -m 666 ids.txt $(DESTDIR)$(VARDIR)/ids.txt ; fi
	
	install -m 644 templates/delphi/* $(DESTDIR)$(VARDIR)/templates/delphi
	install -m 755 gtk-pascal-gen $(DESTDIR)$(BINDIR)
	install -m 755 app/*.py app/gen $(DESTDIR)$(LIBDIR)/app
	if [ ! -L "$(DESTDIR)$(VARDIR)/app" ] ; then ln -s "$(LIBDIR)/app" "$(DESTDIR)$(VARDIR)/app" ; fi
	
clean:
	rm -f gtk-pascal-gen

distclean: clean
