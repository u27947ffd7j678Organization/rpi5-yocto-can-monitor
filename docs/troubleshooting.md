# Troubleshooting

## Boot Stops While Waiting for microSD rootfs

### Symptom

When booting from USB memory, the kernel log appears, but boot stops near this message:

```text
Waiting for root device /dev/mmcblk0p2...
sda: sda1 sda2
[sda] Attached SCSI removable disk
```

### Cause

The USB device is detected as `sda1` and `sda2`, but `cmdline.txt` still tells the kernel to use the microSD root partition:

```text
root=/dev/mmcblk0p2
```

### Investigation

Check the `.wic` partition layout:

```bash
fdisk -l tmp/deploy/images/raspberrypi5/core-image-base-raspberrypi5.rootfs.wic
```

Observed layout:

```text
Partition 1 : FAT32 130MB
Partition 2 : Linux 239MB
```

Mount the boot partition and inspect `cmdline.txt`:

```bash
sudo losetup -Pf tmp/deploy/images/raspberrypi5/core-image-base-raspberrypi5.rootfs.wic
sudo mkdir -p /mnt/boot
sudo mount /dev/loop0p1 /mnt/boot
cat /mnt/boot/cmdline.txt
```

Initial content:

```text
dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait net.ifnames=0
```

### Temporary Fix

Edit `cmdline.txt` to use the USB root partition:

```text
dwc_otg.lpm_enable=0 root=/dev/sda2 rootfstype=ext4 rootwait net.ifnames=0
```

### Reproducible Fix

Set the root partition from Yocto configuration instead of editing the generated image manually.

Add this to `build-rpi5/conf/local.conf`:

```conf
CMDLINE_ROOT_PARTITION = "/dev/sda2"
```

After rebuilding, confirm that the generated `.wic` contains:

```text
dwc_otg.lpm_enable=0 root=/dev/sda2 rootfstype=ext4 rootwait net.ifnames=0
```

## WSL Build Stability

Yocto builds can use a large amount of disk space and generate heavy I/O. On a 256GB C drive, the first build may run into capacity or I/O related problems.

The build was stable with:

- RAM: 32GB
- Free storage: about 351GB
- `BB_NUMBER_THREADS = "6"`
- `PARALLEL_MAKE = "-j6"`
- `USER_CLASSES = ""`

## .wic.bz2 Extraction

Yocto deploy artifacts may be symlinks or hard links. In this environment, direct `bunzip2` extraction was not always convenient.

Use `bzcat` instead:

```bash
bzcat tmp/deploy/images/raspberrypi5/core-image-base-raspberrypi5.rootfs.wic.bz2 \
  > tmp/deploy/images/raspberrypi5/core-image-base-raspberrypi5.rootfs.wic
```

The repository includes `scripts/extract_wic.sh` for this step.

