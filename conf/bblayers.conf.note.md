# bblayers.conf Notes

After running `source oe-init-build-env build-rpi5`, add these layers:

```bash
bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-raspberrypi
```

Confirm with:

```bash
bitbake-layers show-layers
```

Expected layer names include:

```text
core
yocto
yoctobsp
openembedded-layer
meta-python
networking-layer
raspberrypi
```

