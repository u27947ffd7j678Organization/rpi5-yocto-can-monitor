# NetworkManager

[English](networkmanager.en.md) | 日本語

このイメージではNetworkManagerとカスタムWi-Fi接続プロファイルを導入し、Raspberry Pi 5が起動後に自動でWi-Fiへ接続できるようにしています。

## イメージへ追加するパッケージ

カスタムイメージレシピでは以下をインストールします。

```bitbake
networkmanager
networkmanager-config
```

## 設定レシピ

`recipes-connectivity/networkmanager/networkmanager-config/networkmanager-config.bb` は、keyfile形式の接続プロファイルを以下へインストールします。

```text
/etc/NetworkManager/system-connections/
```

インストールされるファイルはmode `0600` である必要があります。権限が緩い接続プロファイルはNetworkManagerに無視されます。

## ローカルWi-Fiテンプレート

リポジトリにはテンプレートだけを含めています。

```text
recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection.example
```

ビルド前にコピーします。

```bash
cp recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection.example \
   recipes-connectivity/networkmanager/networkmanager-config/files/Buffalo-5G-E960.nmconnection
```

その後、以下を実環境の値へ置き換えます。

```ini
ssid=YOUR_WIFI_SSID
psk=YOUR_WIFI_PASSWORD
```

実際の `.nmconnection` ファイルはGitで無視されるため、コミットしません。

## 動作確認

起動後に以下を確認します。

```bash
nmcli device
nmcli connection show
ip addr show wlan0
systemctl status NetworkManager
```

期待される結果:

- `wlan0` がNetworkManagerで管理されている
- 設定した接続が `nmcli connection show` に表示される
- `wlan0` にIPアドレスが割り当てられる
- 起動後にWi-Fiへ自動接続される

