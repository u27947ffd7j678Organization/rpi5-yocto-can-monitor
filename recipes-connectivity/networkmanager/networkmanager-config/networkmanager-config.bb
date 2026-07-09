SUMMARY = "NetworkManager Wi-Fi configuration"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://NetworkManager.conf \
    file://Buffalo-5G-E960.nmconnection \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/NetworkManager
    install -d ${D}${sysconfdir}/NetworkManager/system-connections

    install -m 644 \
        ${WORKDIR}/NetworkManager.conf \
        ${D}${sysconfdir}/NetworkManager/NetworkManager.conf

    install -m 600 \
        ${WORKDIR}/Buffalo-5G-E960.nmconnection \
        ${D}${sysconfdir}/NetworkManager/system-connections/Buffalo-5G-E960.nmconnection
}

FILES:${PN} += "${sysconfdir}/NetworkManager/NetworkManager.conf"
FILES:${PN} += "${sysconfdir}/NetworkManager/system-connections/Buffalo-5G-E960.nmconnection"
