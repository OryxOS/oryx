.PHONY: run clean kernel

all: run-kvm

DEPS := deps

QEMU_FLAGS := -drive format=raw,file=oryx-amd64.hdd\
              -L ovmf\
			  -bios $(DEPS)/ovmf/OVMF.fd\
			  -net none\
			  -m 2048\
			  -no-reboot\
			  -no-shutdown\
			  -debugcon stdio\
			  -vga vmware

kernel:
	cd kernel && make

app-shell:
	cd userland/shell && make

app-count-down:
	cd userland/count-down && make

app-count-up:
	cd userland/count-up && make

libraries:
	cd libraries/au && make
	cd ibraries/syscalls && make
	cd libraries/runtime && make
	cd libraries/system && make

release-amd64: libraries kernel app-count-up app-count-down app-shell;
	cp res/oryx.hdd.part oryx-amd64.hdd
	cp res/uefi-tmp.hdd uefi-tmp.hdd
	
	mmd -i uefi-tmp.hdd efi  
	mmd -i uefi-tmp.hdd efi/boot
	mmd -i uefi-tmp.hdd core
	mmd -i uefi-tmp.hdd userland

	mcopy -i uefi-tmp.hdd kernel/kernel.elf ::core/kernel.elf 
	mcopy -i uefi-tmp.hdd $(DEPS)/limine/BOOTX64.EFI ::efi/boot/bootx64.efi 
	mcopy -i uefi-tmp.hdd res/limine.cfg ::limine.cfg

	mcopy -i uefi-tmp.hdd userland/count-down/count-down.elf ::userland/count-down.elf
	mcopy -i uefi-tmp.hdd userland/count-up/count-up.elf ::userland/count-up.elf
	mcopy -i uefi-tmp.hdd userland/shell/shell.elf ::userland/shell.elf

	dd if=uefi-tmp.hdd of=oryx-amd64.hdd bs=512 count=91669 seek=2048 conv=notrunc

run-kvm: release-amd64
	qemu-system-x86_64 $(QEMU_FLAGS) -enable-kvm

run-tcg: release-amd64
	qemu-system-x86_64 $(QEMU_FLAGS) -d int

clean:
	cd kernel && make clean

	cd libraries/au && make clean
	cd libraries/syscalls && make clean
	cd libraries/runtime && make clean
	cd libraries/system && make clean

	cd userland/count-up && make clean
	cd userland/count-down && make clean
	cd userland/shell && make clean