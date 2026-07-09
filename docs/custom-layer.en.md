# Custom Layer

English | [日本語](custom-layer.md)

`meta-rpi5-can-monitor` separates board bring-up, image composition, connectivity, and access configuration into small recipes.

## Structure

```text
meta-rpi5-can-monitor/
├── conf
├── recipes-core
│   ├── images
│   ├── ssh
│   └── base-files
├── recipes-connectivity
│   └── networkmanager
├── tools
└── docs
```

## Layer Metadata

`conf/layer.conf` registers the layer collection:

```conf
BBFILE_COLLECTIONS += "meta-rpi5-can-monitor"
BBFILE_PRIORITY_meta-rpi5-can-monitor = "6"
LAYERSERIES_COMPAT_meta-rpi5-can-monitor = "scarthgap"
```

## Recipe Separation

Recipes are split by function:

- `recipes-core/images`: image composition and package selection
- `recipes-core/base-files`: base filesystem customization such as `fstab`
- `recipes-core/ssh`: root SSH key installation
- `recipes-connectivity/networkmanager`: Wi-Fi and NetworkManager configuration
- `tools`: host-side helper scripts
- `docs`: design notes and verification steps

This keeps the image recipe readable while allowing each system feature to evolve independently.

## Image Recipe

`rpi5-can-monitor-image.bb` extends `core-image-base` and adds:

- OpenSSH
- Python 3
- Git
- can-utils
- iproute2
- NetworkManager
- Wi-Fi connection configuration
- root authorized keys

The next application-specific layer work can add Qt6, CAN monitor services, Django monitoring, and logging utilities without mixing them into base board bring-up.

