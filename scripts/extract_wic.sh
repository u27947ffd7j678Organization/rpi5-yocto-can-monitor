#!/usr/bin/env bash
set -euo pipefail

IMG_DIR="${IMG_DIR:-tmp/deploy/images/raspberrypi5}"
IMAGE_BASENAME="${IMAGE_BASENAME:-core-image-base-raspberrypi5.rootfs}"
SRC="${IMG_DIR}/${IMAGE_BASENAME}.wic.bz2"
OUT="${IMG_DIR}/${IMAGE_BASENAME}.wic"

if [ ! -f "${SRC}" ]; then
  echo "Image not found: ${SRC}" >&2
  echo "Run this script from the Yocto build directory, or set IMG_DIR." >&2
  exit 1
fi

echo "Extracting:"
echo "  ${SRC}"
echo "to:"
echo "  ${OUT}"

rm -f "${OUT}"
bzcat "${SRC}" > "${OUT}"

echo "Done."
ls -lh "${OUT}"

