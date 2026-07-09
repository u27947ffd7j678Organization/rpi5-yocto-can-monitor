# Raspberry Pi 5 Yocto CAN Monitor Platform

English | [日本語](README.md)

A custom Yocto Linux platform for Raspberry Pi 5, built as the foundation for an embedded CAN monitoring system.

This repository presents a reusable Yocto layer, image recipe, system configuration, and supporting documentation for a Raspberry Pi 5 target that boots from USB, connects to Wi-Fi automatically, supports SSH access, and includes the core tools needed for CAN-oriented application development.

## Project Snapshot

| Area | Implementation |
| --- | --- |
| Target board | Raspberry Pi 5 |
| Yocto release | Scarthgap |
| Custom layer | `meta-rpi5-can-monitor` |
| Image recipe | `rpi5-can-monitor-image` |
| Init system | systemd |
| Network stack | NetworkManager |
| Boot media | USB-first boot with SD fallback |
| Remote access | OpenSSH with root `authorized_keys` recipe |
| Development tools | Python 3, Git, can-utils, iproute2 |

## Implemented Features

- Custom Yocto layer for Raspberry Pi 5 CAN monitor work
- Custom image recipe based on `core-image-base`
- USB boot support for Raspberry Pi 5
- USB-first boot behavior with SD card fallback
- systemd-based init configuration
- NetworkManager installation and Wi-Fi auto-connect recipe
- OpenSSH server for remote access
- Root SSH public key installation recipe
- Python 3 runtime
- Git, can-utils, and iproute2 included in the image
- Utility script for extracting generated `.wic.bz2` images

## Repository Layout

```text
meta-rpi5-can-monitor/
├── conf/
│   └── layer.conf
├── recipes-core/
│   ├── base-files/
│   │   ├── base-files/fstab
│   │   └── base-files_%.bbappend
│   ├── images/
│   │   └── rpi5-can-monitor-image.bb
│   └── ssh/
│       └── root-authorized-keys/
│           ├── files/authorized_keys.example
│           └── root-authorized-keys.bb
├── recipes-connectivity/
│   └── networkmanager/
│       └── networkmanager-config/
│           ├── files/Buffalo-5G-E960.nmconnection.example
│           ├── files/NetworkManager.conf
│           └── networkmanager-config.bb
├── tools/
│   └── extract-wic.sh
└── docs/
    ├── authorized-keys.md
    ├── custom-layer.md
    ├── networkmanager.md
    ├── systemd.md
    └── troubleshooting.md
```

## Layer Setup

The tested Yocto workspace is organized as:

```text
~/yocto/
├── poky/
│   ├── meta-openembedded/
│   ├── meta-raspberrypi/
│   └── build-rpi5/
└── meta-rpi5-can-monitor/
```

Add the layer to `build-rpi5/conf/bblayers.conf`:

```conf
BBLAYERS += " /home/tshig/yocto/meta-rpi5-can-monitor "
```

The layer is compatible with Yocto Scarthgap:

```conf
LAYERSERIES_COMPAT_meta-rpi5-can-monitor = "scarthgap"
```

## Build Configuration

Use Raspberry Pi 5 as the target machine:

```conf
MACHINE = "raspberrypi5"
```

Enable systemd and USB root partition handling in `build-rpi5/conf/local.conf`:

```conf
LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"

BB_NUMBER_THREADS = "6"
PARALLEL_MAKE = "-j6"

USER_CLASSES = ""
CMDLINE_ROOT_PARTITION = "/dev/sda2"

DISTRO_FEATURES:append = " systemd"
DISTRO_FEATURES:remove = "sysvinit"

VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = ""

DISTRO_FEATURES:append = " usrmerge"
```

## Secrets and Local Templates

Private credentials are intentionally not committed.

Before building a personalized image, copy the example files and replace the placeholders:

```bash
cp recipes-core/ssh/root-authorized-keys/files/authorized_keys.example \
   recipes-core/ssh/root-authorized-keys/files/authorized_keys

cp recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection.example \
   recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection
```

Then edit:

- `authorized_keys`
- `Buffalo-5G-E960.nmconnection`

Use real values only in the local working tree. Do not commit those generated files.

## Build

From the Poky directory:

```bash
cd ~/yocto/poky
source oe-init-build-env build-rpi5
bitbake rpi5-can-monitor-image
```

Generated images are placed under:

```text
build-rpi5/tmp/deploy/images/raspberrypi5/
```

## Extract the USB Image

Use the helper script from the Yocto workspace root:

```bash
cd ~/yocto
./meta-rpi5-can-monitor/tools/extract-wic.sh
```

Or pass an explicit deploy directory:

```bash
./meta-rpi5-can-monitor/tools/extract-wic.sh \
  poky/build-rpi5/tmp/deploy/images/raspberrypi5
```

The script finds the newest `.wic.bz2` file and expands it to `.wic`.

## Runtime Verification

After booting the Raspberry Pi 5 image, verify the platform with:

```bash
systemctl --version
systemctl status NetworkManager
journalctl -b
nmcli device
nmcli connection show
ip addr show wlan0
ssh root@<raspberry-pi-ip>
```

Expected result:

- Login prompt appears correctly
- USB boot works
- SD boot remains available as fallback
- Wi-Fi connects automatically after boot
- SSH login works with the installed public key

## Documentation

- [Custom layer design](docs/custom-layer.md)
- [systemd migration](docs/systemd.md)
- [NetworkManager and Wi-Fi auto-connect](docs/networkmanager.md)
- [Root authorized_keys recipe](docs/authorized-keys.md)
- [Troubleshooting](docs/troubleshooting.md)

## Next Steps

- Qt6 application
- CAN monitor application
- Django web monitor
- systemd service units for applications
- CAN interface configuration
- Python logging utilities

## Portfolio Focus

This project demonstrates:

- Practical Yocto layer organization
- Raspberry Pi 5 board bring-up
- Boot issue analysis and reproducible fixes
- systemd and NetworkManager integration
- Secure handling of local credentials through templates
- A staged path from base Linux image to application-specific embedded platform

