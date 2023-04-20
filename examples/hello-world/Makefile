CNTR=docker run --rm -ti -v $(shell pwd)/:/opt/source mikaheim/amiga-cc-toolchain
GCC=$(CNTR) m68k-amigaos-gcc
VC=$(CNTR) vc +kick13 -c99 -O2 -lauto -lamiga -I/opt/amiga/m68k-amigaos/ndk13-include -I/opt/amiga/m68k-amigaos/ndk-include
VC13=$(CNTR) vc +kick13 -c99 -O2 -lauto -lamiga -I/opt/amiga/m68k-amigaos/ndk13-include -I/opt/amiga/m68k-amigaos/ndk-include

SRCS:=$(wildcard *.c)
BINS:=$(SRCS:%.c=gcc/%.exe) $(SRCS:%.c=vc/%.exe) $(SRCS:%.c=vc13/%.exe)
EXE_DIRS:=gcc vc vc13

all: makedirs $(BINS)

makedirs:
	@mkdir $(EXE_DIRS)

gcc/%.exe: %.c
	$(GCC) $< -o $@

vc/%.exe: %.c
	$(VC) $< -o $@

vc13/%.exe: %.c
	$(VC13) $< -o $@

clean:
	@rm -rf *.exe $(EXE_DIRS) 
