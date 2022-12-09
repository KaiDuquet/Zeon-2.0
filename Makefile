SRCS = $(wildcard kernel/*.c drivers/*.c)
HEAD = $(wildcard kernel/*.h drivers/*.h)

CC = i386-elf-gcc
LD = i386-elf-ld

OBJ = ${SRCS:.c=.o}

LDFLAGS = -Ttext 0x1000 --oformat binary
CFLAGS 	= -ffreestanding -fno-pie

all: zeon-image

run: all
	qemu-system-i386 zeon-image

zeon-image: boot/boots.bin kernel.bin
	cat $^ > zeon-image
	qemu-img resize zeon-image +20K

kernel.bin: kernel/kernel_entry.o $(OBJ)
	$(LD) -o $@ $(LDFLAGS) $^

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@
	
%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/boot_inc/' -o $@

clean:
	rm -rf *.bin *.dis *.o zeon-image
	rm -rf kernel/*.o boot/*.bin drivers/*.o

kernel.dis: kernel.bin
	ndisasm -b32 $< > $@
