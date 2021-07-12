# OryxOS Build System
This repository contains instructions and a script that is needed to setup and build OryxOS

## Setup

Before building OryxOS, you need to setup the correct build environment.

### Required packages

​	``make``		``parted``	``ovmf``	``ld.lld``
​	``mtools``	``qemu``		``ldc``		``nasm``

### Instructions

1. Create a folder where everything involving OryxOS will be kept, call it something like ``OryxOS``
2. Clone this repository into the folder
3. Enter the folder and run ``./setup.sh``
4. Once the setup has complete, run ``cd ../`` and then run ``make``
5. If everything has worked, ``qemu`` should open and you should see OryxOS

### Notes

1. The location and name of ``OVMF_CODE.fd`` and ``OVMF_VARS.fd`` changes between systems you may need to modify the given makefile to suite your system
2. The file ``oryx-amd64.hdd`` is the final OS image and can be burnt to a USB flash drive

