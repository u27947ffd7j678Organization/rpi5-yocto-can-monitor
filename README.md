# Raspberry Pi 5 Yocto USB Boot

Raspberry Pi 5 向けに Yocto Project で Linux OS イメージをビルドし、USB メモリまたは USB SSD から起動できることを確認した記録です。

最終的には、Raspberry Pi OS 上で動かしている Qt / Python / Django / CAN 関連の環境を、Yocto ベースの専用 OS イメージとして再現することを目標にしています。

## Environment

### Build host

- Windows PC
- WSL2
- Ubuntu 24.04
- CPU: AMD Ryzen 5 7430U
- Memory: 32GB
- Storage: 約 351GB free

### Target

- Raspberry Pi 5
- Boot media: USB 3.0 memory
- Yocto `MACHINE`: `raspberrypi5`
- Yocto release: `scarthgap`

## Layers

```text
poky
meta-openembedded
  ├── meta-oe
  ├── meta-python
  └── meta-networking
meta-raspberrypi
```

## Quick Start

```bash
mkdir -p ~/yocto
cd ~/yocto

git clone -b scarthgap https://github.com/yoctoproject/poky.git
cd poky

git clone -b scarthgap https://github.com/openembedded/meta-openembedded.git
git clone -b scarthgap https://github.com/agherzan/meta-raspberrypi.git

source oe-init-build-env build-rpi5

bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-raspberrypi
```

`build-rpi5/conf/local.conf` に `conf/local.conf.example` の設定を反映します。

```bash
cd ~/yocto/poky
source oe-init-build-env build-rpi5
bitbake core-image-base
```

生成物は以下に出力されます。

```bash
tmp/deploy/images/raspberrypi5/
```

USB メモリへ書き込む対象は `.wic` イメージです。`.wic.bz2` から展開する場合は `scripts/extract_wic.sh` を使います。

## USB Boot Fix

初期状態の `.wic` では `cmdline.txt` の rootfs 指定が microSD 向けになっていました。

```text
root=/dev/mmcblk0p2
```

USB メモリは起動時に `sda1`, `sda2` として認識されたため、カーネルは次のようなログで停止しました。

```text
Waiting for root device /dev/mmcblk0p2...
sda: sda1 sda2
```

正式対応として、`local.conf` に以下を追加します。

```conf
CMDLINE_ROOT_PARTITION = "/dev/sda2"
```

再ビルド後、生成された `.wic` の `cmdline.txt` が以下になることを確認しました。

```text
root=/dev/sda2
```

## Boot Result

Raspberry Pi 5 に USB メモリを挿し、microSD を抜いた状態で起動しました。

起動ログが表示され、最終的にログインプロンプトまで到達しました。

```text
login: root
Password: なし
root@raspberrypi5:~#
```

Yocto でビルドした Raspberry Pi 5 向け Linux イメージが、USB メモリから正常に起動することを確認できました。

## Documentation

- [Build log](docs/build-log.md)
- [USB boot procedure](docs/usb-boot.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Repository structure](docs/repository-structure.md)

## Next Steps

- OpenSSH を追加し、LAN 経由で `ssh root@<IP>` できるようにする
- Python 3、Git、can-utils、iproute2、systemd 関連ツールを追加する
- Qt6 / Python Logger / Django Web Monitor / CAN 設定を再現する
- `meta-rpi5-can-monitor` のような独自レイヤにアプリ、設定、systemd service、イメージレシピをまとめる

