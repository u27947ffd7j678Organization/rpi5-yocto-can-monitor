# Build Log

Raspberry Pi 5 向け Yocto イメージを WSL2 / Ubuntu 24.04 上でビルドした記録です。

## Build Environment

- Windows PC
- WSL2
- Ubuntu 24.04
- CPU: AMD Ryzen 5 7430U
- Memory: 32GB
- Storage: 約 351GB free

## Target

- Raspberry Pi 5
- Boot media: USB 3.0 memory
- Yocto `MACHINE`: `raspberrypi5`

## Source Setup

```bash
mkdir -p ~/yocto
cd ~/yocto

git clone -b scarthgap https://github.com/yoctoproject/poky.git
cd poky

git clone -b scarthgap https://github.com/openembedded/meta-openembedded.git
git clone -b scarthgap https://github.com/agherzan/meta-raspberrypi.git
```

## Layer Setup

```bash
source oe-init-build-env build-rpi5

bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-raspberrypi
```

Layer check:

```bash
bitbake-layers show-layers
```

Confirmed layer example:

```text
core
yocto
yoctobsp
openembedded-layer
meta-python
networking-layer
raspberrypi
```

## Main local.conf Settings

```conf
MACHINE = "raspberrypi5"

LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"

BB_NUMBER_THREADS = "6"
PARALLEL_MAKE = "-j6"

USER_CLASSES = ""

CMDLINE_ROOT_PARTITION = "/dev/sda2"
```

### Notes

- `MACHINE = "raspberrypi5"` selects the Raspberry Pi 5 machine definition from `meta-raspberrypi`.
- `LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"` accepts the restricted firmware license required by Raspberry Pi 5 Wi-Fi / Bluetooth related firmware.
- `USER_CLASSES = ""` disables build statistics after WSL I/O errors related to `buildstats`.
- `CMDLINE_ROOT_PARTITION = "/dev/sda2"` makes the generated image mount the USB rootfs instead of waiting for a microSD rootfs.

## Build Command

```bash
cd ~/yocto/poky
source oe-init-build-env build-rpi5
bitbake core-image-base
```

Successful build log example:

```text
NOTE: Tasks Summary: Attempted 5233 tasks of which 0 didn't need to be rerun and all succeeded.
```

## Generated Artifacts

Output directory:

```bash
tmp/deploy/images/raspberrypi5/
```

Main files:

```text
core-image-base-raspberrypi5.rootfs.wic.bz2
core-image-base-raspberrypi5.rootfs.wic.bmap
core-image-base-raspberrypi5.rootfs.ext3
core-image-base-raspberrypi5.rootfs.tar.bz2
core-image-base-raspberrypi5.rootfs.manifest
```

The `.wic` image is the file written to the USB boot media.

