ARCH = i686-elf

CC = $(ARCH)-gcc
AS = $(ARCH)-as

CCFLAGS = -O2 -Wall -ffreestanding -std=gnu99 -std=gnu99
LDFLAGS = -T kernel/arch/$(ARCH)/linker.ld -ffreestanding -O2 -nostdlib

CFILES = $(shell find kernel/src -type f -name '*.c') \
				 $(shell find kernel/arch/$(ARCH) -type f -name '*.c')
				 
SFILES = $(shell find kernel/src -type f -name '*.s') \
				 $(shell find kernel/arch/$(ARCH) -type f -name '*.s')

OBJS = $(patsubst %.c,%.o,$(CFILES)) \
				$(patsubst %.s,%.o,$(SFILES))

.PHONY: all clean qemu
all: CoastalOS.bin

clean:
	rm -rf $(OBJS)
	rm -f CoastalOS.bin
	
qemu: CoastalOS.bin
	qemu-system-i386 --kernel CoastalOS.bin
	
CoastalOS.bin: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o CoastalOS.bin

%.o: %.c
	$(CC) -c $< -o $@ $(CCFLAGS)

%.o: %.S
	$(AS) $< -o $@
