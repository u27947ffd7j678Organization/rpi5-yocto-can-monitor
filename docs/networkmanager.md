# NetworkManager

The image installs NetworkManager and a custom Wi-Fi connection profile so the Raspberry Pi 5 connects to Wi-Fi automatically after boot.

## Image Package

The custom image recipe installs:

```bitbake
networkmanager
networkmanager-config
```

## Configuration Recipe

`recipes-connectivity/networkmanager/networkmanager-config/networkmanager-config.bb` installs a keyfile connection profile into:

```text
/etc/NetworkManager/system-connections/
```

The installed file must use mode `0600`; NetworkManager ignores insecure connection profiles.

## Local Wi-Fi Template

The repository includes:

```text
recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection.example
```

Copy it before building:

```bash
cp recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection.example \
   recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection
```

Then replace:

```ini
ssid=YOUR_WIFI_SSID
psk=YOUR_WIFI_PASSWORD
```

The real `.nmconnection` file is ignored by Git and should not be committed.

## Verification

After boot:

```bash
nmcli device
nmcli connection show
ip addr show wlan0
systemctl status NetworkManager
```

Expected result:

- `wlan0` is managed by NetworkManager
- the configured connection appears in `nmcli connection show`
- `wlan0` receives an IP address
- Wi-Fi connects automatically after boot

