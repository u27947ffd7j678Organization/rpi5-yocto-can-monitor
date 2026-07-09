# systemd

[English](systemd.en.md) | 日本語

このプラットフォームでは、デフォルトのSysVinit系構成ではなくsystemdを使用します。

## systemdを採用した理由

ターゲットシステムでは、複数の常駐サービスを扱う予定です。

- NetworkManager
- SSH
- 今後追加するCAN monitor application service
- 今後追加するDjango web monitor service
- 今後追加するログ出力ユーティリティ

systemdを使うことで、サービス管理、依存関係の制御、`journalctl` によるログ確認、起動時のunit有効化を標準的な方法で扱えます。

## local.conf設定

```conf
DISTRO_FEATURES:append = " systemd"
DISTRO_FEATURES:remove = "sysvinit"

VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = ""

DISTRO_FEATURES:append = " usrmerge"
```

`usrmerge` は、systemdを前提にした多くのパッケージが `/usr` 統合レイアウトを期待するため有効化しています。

## よく使うコマンド

systemdのバージョン確認:

```bash
systemctl --version
```

失敗しているunitの確認:

```bash
systemctl --failed
```

サービス状態の確認:

```bash
systemctl status NetworkManager
```

起動ログの確認:

```bash
journalctl -b
```

リアルタイムログの追跡:

```bash
journalctl -f
```

これらは、起動、ネットワーク、SSH、今後追加するアプリケーションサービスのデバッグで基本になるコマンドです。

