echo "Setting up a build environment for OryxOS"

## Folders ##
mkdir ../fs-root
mkdir deps

## Kernel ##
git clone https://github.com/OryxOS/kernel.git

## Libraries ##
git clone https://github.com/OryxOS/libraries.git

## Userland ##
git clone https://github.com/OryxOS/userland.git

## Limine ##
git clone https://github.com/limine-bootloader/limine.git deps/limine --branch=v3.0-branch-binary --depth=1

## OVMF ##
mkdir deps/ovmf
cd deps/ovmf && curl -o OVMF-X64.zip https://efi.akeo.ie/OVMF/OVMF-X64.zip && 7z x OVMF-X64.zip
cd ../../

## Image file ##
dd if=/dev/zero of=res/oryx.hdd.part bs=512 count=131072
parted res/oryx.hdd.part -s -a minimal mklabel gpt 
parted res/oryx.hdd.part -s -a minimal mkpart EFI FAT16 2048s 100% 
parted res/oryx.hdd.part -s -a minimal toggle 1 boot

## Temporary image file ##
dd if=/dev/zero of=res/uefi-tmp.hdd bs=512 count=91669
mformat -i res/uefi-tmp.hdd -h 32 -t 32 -n 64 -c 1

echo "Setup complete. Run 'make' to build a distribution of OryxOS"