# systemd

The platform uses systemd instead of the default SysVinit-style setup.

## Why systemd

The target system is expected to run multiple long-lived services:

- NetworkManager
- SSH
- future CAN monitor application services
- future Django web monitor services
- future logging utilities

systemd provides a consistent service model, dependency handling, logs through `journalctl`, and a standard way to enable application units at boot.

## local.conf Settings

```conf
DISTRO_FEATURES:append = " systemd"
DISTRO_FEATURES:remove = "sysvinit"

VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = ""

DISTRO_FEATURES:append = " usrmerge"
```

`usrmerge` is enabled because many modern systemd-oriented packages expect a merged `/usr` layout.

## Useful Commands

Check the systemd version:

```bash
systemctl --version
```

List failed units:

```bash
systemctl --failed
```

Check a service:

```bash
systemctl status NetworkManager
```

Read boot logs:

```bash
journalctl -b
```

Follow live logs:

```bash
journalctl -f
```

These commands are the baseline for debugging boot, network, SSH, and future application services.

