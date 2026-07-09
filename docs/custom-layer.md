# カスタムレイヤ

[English](custom-layer.en.md) | 日本語

`meta-rpi5-can-monitor` は、ボード bring-up、イメージ構成、ネットワーク、SSHアクセス設定を小さなレシピに分けて管理するカスタムYoctoレイヤです。

## 構成

```text
meta-rpi5-can-monitor/
├── conf
├── recipes-core
│   ├── images
│   ├── ssh
│   └── base-files
├── recipes-connectivity
│   └── networkmanager
├── tools
└── docs
```

## レイヤメタデータ

`conf/layer.conf` でレイヤコレクションを登録します。

```conf
BBFILE_COLLECTIONS += "meta-rpi5-can-monitor"
BBFILE_PRIORITY_meta-rpi5-can-monitor = "6"
LAYERSERIES_COMPAT_meta-rpi5-can-monitor = "scarthgap"
```

## レシピ分割の考え方

機能ごとにレシピを分けています。

- `recipes-core/images`: イメージ構成と追加パッケージの選定
- `recipes-core/base-files`: `fstab` などのベースファイルシステム設定
- `recipes-core/ssh`: rootユーザー向けSSH公開鍵の配置
- `recipes-connectivity/networkmanager`: Wi-FiとNetworkManager設定
- `tools`: ホスト側で使う補助スクリプト
- `docs`: 設計メモと動作確認手順

この分割により、イメージレシピを読みやすく保ちながら、各機能を独立して拡張できます。

## イメージレシピ

`rpi5-can-monitor-image.bb` は `core-image-base` を拡張し、以下を追加します。

- OpenSSH
- Python 3
- Git
- can-utils
- iproute2
- NetworkManager
- Wi-Fi接続設定
- root authorized keys

今後は、Qt6、CAN monitor service、Django monitor、ログ出力ユーティリティなどを、ベースのボード bring-up と分離したまま追加できます。

