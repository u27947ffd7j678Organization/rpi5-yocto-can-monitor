# Repository Structure

This repository documents a Raspberry Pi 5 Yocto USB boot setup.

```text
rpi5-yocto-usb-boot/
├── README.md
├── docs/
│   ├── build-log.md
│   ├── troubleshooting.md
│   ├── usb-boot.md
│   └── repository-structure.md
├── scripts/
│   ├── setup_layers.sh
│   └── extract_wic.sh
├── conf/
│   ├── local.conf.example
│   └── bblayers.conf.note.md
├── images/
│   └── README.md
└── .gitignore
```

## What Is Included

- Human-readable build notes
- Layer setup script
- `.wic.bz2` extraction script
- Example `local.conf`
- Notes about expected `bblayers.conf` entries
- Yocto-oriented `.gitignore`

## What Is Not Included

This repository intentionally does not include:

- Yocto build output
- downloaded source archives
- `tmp/`
- `sstate-cache/`
- generated `.wic` images
- generated rootfs archives

Those files are large and should be regenerated from Yocto sources and configuration.

