all: package

PPUS = output/eggtray/ueggtraymanager.ppu \
output/eggtray/ueggtrayicon.ppu

OS = output/eggtray/ueggtraymanager.o \
output/eggtray/ueggtrayicon.o

#SOURCES = 

package: $(PPUS)

FLAGS = -dGTK2_4 -dneed_icloneable -dneed_iweakref -dgtk2q_standalone \
	-dneed_igclosure -Mdelphi \
	-Fu../../varrec \
	-Fustatic -Fi. -Fistatic \
	-Fioutput/gnome-canvas \
	-Fuoutput/gnome-canvas \
	-g -XX -OG3 -vewni -l

	# -gl -vut
# TODO 'enable' assertions!

# -gw

# gw dwarf debugging info

%.ppu: %.pas
	fpc $(FLAGS) $<

clean:
	rm -f $(PPUS) $(OS)

distclean: clean

install: all
	cp $(PPUS) $(OS) /usr/lib/fpc/1.9.9/units/linux/eggtrayq/

