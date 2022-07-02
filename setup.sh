echo "Setting up a build environment for OryxOS"

## Folders ##
mkdir ../depend
mkdir ../fs-root
mkdir ../resource

## Kernel ##
git clone https://github.com/OryxOS/kernel ../kernel

## Libraries ##
git clone https://github.com/OryxOS/libraries ../libraries

## Userland ##
git clone https://github.com/OryxOS/userland ../userland

## Limine ##
git clone https://github.com/limine-bootloader/limine.git ../depend --branch=v3.0-branch-binary --depth=1 

## Image file ##
dd if=/dev/zero of=../resource/oryx.hdd.part bs=512 count=131072
parted ../resource/oryx.hdd.part -s -a minimal mklabel gpt 
parted ../resource/oryx.hdd.part -s -a minimal mkpart EFI FAT16 2048s 100% 
parted ../resource/oryx.hdd.part -s -a minimal toggle 1 boot

## Temporary image file ##
dd if=/dev/zero of=../resource/uefi-tmp.hdd bs=512 count=91669
mformat -i ../resource/uefi-tmp.hdd -h 32 -t 32 -n 64 -c 1

## Setup file structure ##
mkdir ../fs-root/core
mkdir ../fs-root/efi/
mkdir ../fs-root/efi/boot
mkdir ../fs-root/applications
cp limine.cfg ../fs-root/limine.cfg
cp ../depend/BOOTX64.EFI ../fs-root/efi/boot/bootx64.efi
cp project.make ../Makefile

echo "Setup complete. Return to the root directory and run 'make' to build a distribution of OryxOS"