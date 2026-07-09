# Troubleshooting

## Timed out waiting for device /dev/mmcblk0p1

### Problem

During boot, systemd waits for a fixed SD card boot partition:

```text
Timed out waiting for device /dev/mmcblk0p1
```

This can delay or block a USB-booted system.

### Cause

The default `fstab` referenced the SD card boot partition as a required device. When booting from USB, that partition may not exist, even though the USB root filesystem is valid.

### Solution

Extend `base-files` with a bbappend:

```text
recipes-core/base-files/base-files_%.bbappend
```

Install a custom `fstab`:

```text
recipes-core/base-files/base-files/fstab
```

The custom file keeps the root filesystem on `/dev/root`, and marks boot partitions as optional:

```fstab
/dev/root      /          auto  defaults  1  1
/dev/mmcblk0p1 /boot      vfat  defaults,nofail,x-systemd.device-timeout=1s  0  0
/dev/sda1      /boot-usb  vfat  defaults,nofail,x-systemd.device-timeout=1s  0  0
```

### Result

- USB boot works
- SD boot still works
- Missing boot media does not block startup
- Login prompt appears correctly

## Wi-Fi Does Not Connect

Check that the real `.nmconnection` file exists before building:

```bash
ls recipes-connectivity/networkmanager/networkmanager-config/files/*.nmconnection
```

Check that the installed profile is mode `0600` in the recipe:

```bitbake
install -m 600 ...
```

On the target:

```bash
systemctl status NetworkManager
nmcli device
nmcli connection show
journalctl -u NetworkManager -b
```

## SSH Key Login Fails

Confirm that the real key file was copied before building:

```bash
ls recipes-core/ssh/root-authorized-keys/files/authorized_keys
```

On the target, verify that the key was installed:

```bash
ls -l /home/root/.ssh/authorized_keys
```

The file should be readable only by root.

