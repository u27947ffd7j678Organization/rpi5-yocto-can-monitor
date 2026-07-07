#!/usr/bin/env bash
set -euo pipefail

YOCTO_DIR="${YOCTO_DIR:-$HOME/yocto}"
POKY_BRANCH="${POKY_BRANCH:-scarthgap}"
OE_BRANCH="${OE_BRANCH:-scarthgap}"
RPI_BRANCH="${RPI_BRANCH:-scarthgap}"
BUILD_DIR="${BUILD_DIR:-build-rpi5}"

mkdir -p "${YOCTO_DIR}"
cd "${YOCTO_DIR}"

if [ ! -d poky ]; then
  git clone -b "${POKY_BRANCH}" https://github.com/yoctoproject/poky.git
fi

cd poky

if [ ! -d meta-openembedded ]; then
  git clone -b "${OE_BRANCH}" https://github.com/openembedded/meta-openembedded.git
fi

if [ ! -d meta-raspberrypi ]; then
  git clone -b "${RPI_BRANCH}" https://github.com/agherzan/meta-raspberrypi.git
fi

set +u
source oe-init-build-env "${BUILD_DIR}"
set -u

bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-raspberrypi

bitbake-layers show-layers

