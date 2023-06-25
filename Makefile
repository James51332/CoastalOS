ARCH = i686-elf

CC = $(ARCH)-gcc
AS = $(ARCH)-as

CCFLAGS = -O2 -Wall -ffreestanding -std=gnu99 -std=gnu99 -Ikernel/arch/$(ARCH)
LDFLAGS = -T kernel/arch/$(ARCH)/linker.ld -ffreestanding -O2 -nostdlib

CFILES = $(shell find kernel/src -type f -name '*.c') \
				 $(shell find kernel/arch/$(ARCH) -type f -name '*.c')
				 
SFILES = $(shell find kernel/src -type f -name '*.s') \
				 $(shell find kernel/arch/$(ARCH) -type f -name '*.s')

OBJS = $(patsubst %.c,%.o,$(CFILES)) \
				$(patsubst %.s,%.o,$(SFILES))

.PHONY: all clean qemu
all: CoastalOS.iso

clean:
	rm -rf $(OBJS)
	rm -f CoastalOS.bin
	rm -f CoastalOS.iso
	rm -rf isodir
	
qemu: CoastalOS.iso
	qemu-system-i386 -cdrom CoastalOS.iso
	
CoastalOS.iso: CoastalOS.bin
	mkdir -p isodir/boot/grub
	cp CoastalOS.bin isodir/boot/CoastalOS.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o CoastalOS.iso isodir

CoastalOS.bin: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o CoastalOS.bin

%.o: %.c
	$(CC) -c $< -o $@ $(CCFLAGS)

%.o: %.S
	$(AS) $< -o $@
