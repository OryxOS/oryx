.PHONY: run clean kernel

all: run

kernel:
	cd kernel && make

application-shell:
	cd userland/shell && make

libraries:
	cd ../../libraries/au && make
	cd ../../libraries/syscalls && make
	cd ../../libraries/runtime && make
	cd ../../libraries/system && make

release-amd64: libraries kernel application-shell
	cp kernel/kernel.elf fs-root/core/kernel.elf

	cp userland/shell/shell.elf fs-root/applications/shell.elf

	cp resource/oryx.hdd.part oryx-amd64.hdd
	cp resource/uefi-tmp.hdd uefi-tmp.hdd
	
	mmd -i uefi-tmp.hdd efi  
	mmd -i uefi-tmp.hdd efi/boot
	mmd -i uefi-tmp.hdd core
	mmd -i uefi-tmp.hdd applications

	mcopy -i uefi-tmp.hdd fs-root/core/kernel.elf ::core/kernel.elf 
	mcopy -i uefi-tmp.hdd fs-root/efi/boot/bootx64.efi ::efi/boot/bootx64.efi 
	mcopy -i uefi-tmp.hdd fs-root/limine.cfg ::limine.cfg

	mcopy -i uefi-tmp.hdd fs-root/applications/shell.elf ::applications/shell.elf

	dd if=uefi-tmp.hdd of=oryx-amd64.hdd bs=512 count=91669 seek=2048 conv=notrunc

run: release-amd64
	qemu-system-x86_64 -drive format=raw,file=oryx-amd64.hdd -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_CODE.fd,readonly=on -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd,readonly=on -enable-kvm -net none -m 2048 -no-reboot -no-shutdown -d int -debugcon stdio -vga vmware

clean:
	cd kernel && make clean
	cd userland/shell && make clean