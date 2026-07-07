# USB Boot Procedure

This document summarizes how to write and boot the Yocto-generated Raspberry Pi 5 image from USB memory.

## 1. Build the Image

```bash
cd ~/yocto/poky
source oe-init-build-env build-rpi5
bitbake core-image-base
```

## 2. Locate the Image

The generated files are placed under:

```bash
tmp/deploy/images/raspberrypi5/
```

The compressed `.wic` image is usually:

```text
core-image-base-raspberrypi5.rootfs.wic.bz2
```

## 3. Extract the .wic Image

From the `poky` directory:

```bash
./scripts/extract_wic.sh
```

Or manually:

```bash
bzcat tmp/deploy/images/raspberrypi5/core-image-base-raspberrypi5.rootfs.wic.bz2 \
  > tmp/deploy/images/raspberrypi5/core-image-base-raspberrypi5.rootfs.wic
```

## 4. Write the Image on Windows

Use Raspberry Pi Imager on Windows.

1. Start Raspberry Pi Imager.
2. Choose OS.
3. Select `Use custom`.
4. Select `core-image-base-raspberrypi5.rootfs.wic`.
5. Select the USB memory as the target.
6. Write the image.

## 5. Boot Raspberry Pi 5

1. Insert the USB memory into Raspberry Pi 5.
2. Remove the microSD card.
3. Power on Raspberry Pi 5.
4. Wait for the login prompt.

Expected login:

```text
login: root
Password: なし
```

Expected shell prompt:

```text
root@raspberrypi5:~#
```

## Important Configuration

For USB boot, the generated `cmdline.txt` must point to the USB root partition:

```text
root=/dev/sda2
```

Set this in `local.conf`:

```conf
CMDLINE_ROOT_PARTITION = "/dev/sda2"
```

