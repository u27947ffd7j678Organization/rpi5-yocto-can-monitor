#!/usr/bin/env bash
set -euo pipefail

IMAGE_DIR="${1:-poky/build-rpi5/tmp/deploy/images/raspberrypi5}"

if [ ! -d "$IMAGE_DIR" ]; then
    echo "ERROR: image directory not found: $IMAGE_DIR"
    exit 1
fi

WIC_BZ2="$(ls -t "$IMAGE_DIR"/*.wic.bz2 2>/dev/null | head -n 1 || true)"

if [ -z "$WIC_BZ2" ]; then
    echo "ERROR: .wic.bz2 not found in $IMAGE_DIR"
    exit 1
fi

WIC_FILE="${WIC_BZ2%.bz2}"

echo "Input : $WIC_BZ2"
echo "Output: $WIC_FILE"

rm -f "$WIC_FILE"
bzcat "$WIC_BZ2" > "$WIC_FILE"

echo "Done."
ls -lh "$WIC_FILE"

