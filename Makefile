### COMMAND OPTIONS

# If you're using a specific nasm binary, run make like:
# NASM=/path/to/nasm make -e
NASM = nasm


### MAKE OPTIONS
IMAGESIZE = 16


_build:
	mkdir -p build

BMFSmbr.bin: _build
	${NASM} -Isrc/ src/bootsectors/bmfs_mbr.asm -o build/BMFSmbr.bin

pure64.sys: _build
	${NASM} -Isrc/ src/pure64.asm -o build/pure64.sys

img: _build BMFSmbr.bin pure64.sys
	dd if=/dev/zero of=build/system.img bs=1048576 count=${IMAGESIZE}
	dd if=build/BMFSmbr.bin of=build/system.img bs=512 conv=notrunc
	dd if=build/pure64.sys of=build/system.img bs=512 conv=notrunc seek=16

clean:
	rm -r build
