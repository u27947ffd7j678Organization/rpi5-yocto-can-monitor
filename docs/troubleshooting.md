# トラブルシュート

[English](troubleshooting.en.md) | 日本語

## Timed out waiting for device /dev/mmcblk0p1

### 現象

起動中、systemdが固定のSDカードbootパーティションを待ち続けます。

```text
Timed out waiting for device /dev/mmcblk0p1
```

USBブート時に、この待ち時間によって起動が遅延したり、停止したように見えたりします。

### 原因

デフォルトの `fstab` が、SDカードのbootパーティションを必須デバイスとして参照していました。USBから起動する場合、そのパーティションが存在しないことがあります。一方で、USB上のroot filesystem自体は正常です。

### 対応

`base-files` をbbappendで拡張します。

```text
recipes-core/base-files/base-files_%.bbappend
```

カスタム `fstab` をインストールします。

```text
recipes-core/base-files/base-files/fstab
```

カスタム `fstab` ではroot filesystemを `/dev/root` のまま扱い、bootパーティションを任意扱いにします。

```fstab
/dev/root      /          auto  defaults  1  1
/dev/mmcblk0p1 /boot      vfat  defaults,nofail,x-systemd.device-timeout=1s  0  0
/dev/sda1      /boot-usb  vfat  defaults,nofail,x-systemd.device-timeout=1s  0  0
```

### 結果

- USBブートが成功する
- SDカードブートも引き続き利用できる
- 存在しないbootメディアで起動がブロックされない
- ログインプロンプトが正常に表示される

## Wi-Fiに接続できない

ビルド前に実際の `.nmconnection` ファイルが存在することを確認します。

```bash
ls recipes-connectivity/networkmanager/networkmanager-config/files/*.nmconnection
```

インストールされるプロファイルがレシピ内でmode `0600` になっていることを確認します。

```bitbake
install -m 600 ...
```

ターゲット上で確認します。

```bash
systemctl status NetworkManager
nmcli device
nmcli connection show
journalctl -u NetworkManager -b
```

## SSH鍵ログインに失敗する

ビルド前に実際の鍵ファイルをコピーしていることを確認します。

```bash
ls recipes-core/ssh/root-authorized-keys/files/authorized_keys
```

ターゲット上で鍵がインストールされていることを確認します。

```bash
ls -l /home/root/.ssh/authorized_keys
```

このファイルはrootだけが読める権限になっている必要があります。

