# Images

Do not commit generated Yocto images to this repository.

Generated files such as `.wic`, `.wic.bz2`, `.bmap`, `.ext3`, `.tar.bz2`, and rootfs archives are intentionally ignored by `.gitignore`.

Regenerate them from the Yocto build environment:

```bash
cd ~/yocto/poky
source oe-init-build-env build-rpi5
bitbake core-image-base
```

Output directory:

```bash
tmp/deploy/images/raspberrypi5/
```

