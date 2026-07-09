# Raspberry Pi 5 Yocto CAN Monitor Platform

[English](README.en.md) | 日本語

Raspberry Pi 5 向けに構築した、CAN監視システム用のカスタムYocto Linuxプラットフォームです。

このリポジトリでは、USBブート、Wi-Fi自動接続、SSHログイン、CAN開発に必要な基本ツールを備えたRaspberry Pi 5向けYocto環境を、再利用可能なカスタムレイヤとしてまとめています。

## プロジェクト概要

| 項目 | 内容 |
| --- | --- |
| ターゲットボード | Raspberry Pi 5 |
| Yoctoリリース | Scarthgap |
| カスタムレイヤ | `meta-rpi5-can-monitor` |
| イメージレシピ | `rpi5-can-monitor-image` |
| initシステム | systemd |
| ネットワーク管理 | NetworkManager |
| 起動メディア | USB優先ブート、SDカードフォールバック対応 |
| リモートアクセス | OpenSSH + root `authorized_keys` レシピ |
| 開発ツール | Python 3, Git, can-utils, iproute2 |

## 実装済み機能

- Raspberry Pi 5 CAN監視用途向けのカスタムYoctoレイヤ
- `core-image-base` をベースにしたカスタムイメージレシピ
- Raspberry Pi 5のUSBブート対応
- USB優先ブートとSDカードフォールバック
- systemdベースのinit構成
- NetworkManagerの導入とWi-Fi自動接続レシピ
- リモートアクセス用OpenSSH
- rootユーザー向けSSH公開鍵インストールレシピ
- Python 3ランタイム
- Git、can-utils、iproute2の追加
- 生成された `.wic.bz2` を展開する補助スクリプト

## リポジトリ構成

```text
meta-rpi5-can-monitor/
├── conf/
│   └── layer.conf
├── recipes-core/
│   ├── base-files/
│   │   ├── base-files/fstab
│   │   └── base-files_%.bbappend
│   ├── images/
│   │   └── rpi5-can-monitor-image.bb
│   └── ssh/
│       └── root-authorized-keys/
│           ├── files/authorized_keys.example
│           └── root-authorized-keys.bb
├── recipes-connectivity/
│   └── networkmanager/
│       └── networkmanager-config/
│           ├── files/Buffalo-5G-E960.nmconnection.example
│           ├── files/NetworkManager.conf
│           └── networkmanager-config.bb
├── tools/
│   └── extract-wic.sh
└── docs/
    ├── authorized-keys.md
    ├── custom-layer.md
    ├── networkmanager.md
    ├── systemd.md
    └── troubleshooting.md
```

## レイヤ構成

検証に使用したYoctoワークスペースは以下の構成です。

```text
~/yocto/
├── poky/
│   ├── meta-openembedded/
│   ├── meta-raspberrypi/
│   └── build-rpi5/
└── meta-rpi5-can-monitor/
```

`build-rpi5/conf/bblayers.conf` にカスタムレイヤを追加します。

```conf
BBLAYERS += " /home/tshig/yocto/meta-rpi5-can-monitor "
```

このレイヤはYocto Scarthgap向けです。

```conf
LAYERSERIES_COMPAT_meta-rpi5-can-monitor = "scarthgap"
```

## ビルド設定

ターゲットMACHINEはRaspberry Pi 5です。

```conf
MACHINE = "raspberrypi5"
```

`build-rpi5/conf/local.conf` では、systemd化とUSB rootfs向け設定を行います。

```conf
LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"

BB_NUMBER_THREADS = "6"
PARALLEL_MAKE = "-j6"

USER_CLASSES = ""
CMDLINE_ROOT_PARTITION = "/dev/sda2"

DISTRO_FEATURES:append = " systemd"
DISTRO_FEATURES:remove = "sysvinit"

VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = ""

DISTRO_FEATURES:append = " usrmerge"
```

## 秘密情報とテンプレート

Wi-FiパスワードやSSH公開鍵など、個人環境に依存する情報はコミットしません。

ビルド前にテンプレートをコピーし、プレースホルダーを実際の値に置き換えます。

```bash
cp recipes-core/ssh/root-authorized-keys/files/authorized_keys.example \
   recipes-core/ssh/root-authorized-keys/files/authorized_keys

cp recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection.example \
   recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection
```

編集対象:

- `authorized_keys`
- `Buffalo-5G-E960.nmconnection`

実際の認証情報を含むファイルはローカル作業ツリーだけに置き、Gitにはコミットしません。

## ビルド

Pokyディレクトリからビルドします。

```bash
cd ~/yocto/poky
source oe-init-build-env build-rpi5
bitbake rpi5-can-monitor-image
```

生成物は以下に出力されます。

```text
build-rpi5/tmp/deploy/images/raspberrypi5/
```

## USBイメージの展開

Yoctoワークスペース直下から補助スクリプトを実行します。

```bash
cd ~/yocto
./meta-rpi5-can-monitor/tools/extract-wic.sh
```

deployディレクトリを明示することもできます。

```bash
./meta-rpi5-can-monitor/tools/extract-wic.sh \
  poky/build-rpi5/tmp/deploy/images/raspberrypi5
```

このスクリプトは最新の `.wic.bz2` を探し、`.wic` として展開します。

## 動作確認

Raspberry Pi 5でイメージを起動した後、以下のコマンドで状態を確認します。

```bash
systemctl --version
systemctl status NetworkManager
journalctl -b
nmcli device
nmcli connection show
ip addr show wlan0
ssh root@<raspberry-pi-ip>
```

期待される結果:

- ログインプロンプトが正常に表示される
- USBブートが成功する
- SDカードブートもフォールバックとして利用できる
- 起動後にWi-Fiへ自動接続される
- インストール済み公開鍵でSSHログインできる

## ドキュメント

- [カスタムレイヤ設計](docs/custom-layer.md)
- [systemd移行](docs/systemd.md)
- [NetworkManagerとWi-Fi自動接続](docs/networkmanager.md)
- [root authorized_keysレシピ](docs/authorized-keys.md)
- [トラブルシュート](docs/troubleshooting.md)

## 今後の拡張

- Qt6アプリケーション
- CAN Monitorアプリケーション
- Django Web Monitor
- アプリケーション用systemd service
- CANインターフェース設定
- Pythonログ出力ユーティリティ

## ポートフォリオとしての見どころ

このプロジェクトでは、以下の実装力を示しています。

- Yoctoカスタムレイヤの実践的な構成
- Raspberry Pi 5のボード bring-up
- USBブート問題の原因調査と再現可能な修正
- systemd / NetworkManagerの組み込み
- テンプレート化による秘密情報の安全な扱い
- ベースLinuxイメージからアプリケーション専用組込みプラットフォームへ発展させる設計

