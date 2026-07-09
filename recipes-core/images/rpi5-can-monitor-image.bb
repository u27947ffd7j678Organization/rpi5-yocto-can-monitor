require recipes-core/images/core-image-base.bb

DESCRIPTION = "Raspberry Pi 5 CAN Monitor image"

IMAGE_INSTALL:append = " \
    openssh \
    python3 \
    git \
    can-utils \
    iproute2 \
    root-authorized-keys \
    networkmanager \
    networkmanager-config \
"

