.PHONY: run clean kernel

all: run

kernel:
	cd kernel && make

release-amd64: kernel
	cp kernel/oryx.kernel fs-root/core/oryx.kernel

	cp resource/oryx.hdd.part oryx-amd64.hdd
	cp resource/uefi-tmp.hdd uefi-tmp.hdd
	
	mmd -i uefi-tmp.hdd efi  
	mmd -i uefi-tmp.hdd efi/boot
	mmd -i uefi-tmp.hdd core

	mcopy -i uefi-tmp.hdd fs-root/core/oryx.kernel ::core/oryx.kernel 
	mcopy -i uefi-tmp.hdd fs-root/efi/boot/bootx64.efi ::efi/boot/bootx64.efi 
	mcopy -i uefi-tmp.hdd fs-root/limine.cfg ::limine.cfg

	dd if=uefi-tmp.hdd of=oryx-amd64.hdd bs=512 count=91669 seek=2048 conv=notrunc

run: release-amd64
	qemu-system-x86_64 -drive format=raw,file=oryx-amd64.hdd -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_CODE.fd,readonly=on -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd,readonly=on -enable-kvm -net none -m 2048 -no-reboot -no-shutdown -d int -debugcon stdio -vga vmware

clean:
	cd kernel && make clean