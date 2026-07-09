# root authorized_keys

[English](authorized-keys.en.md) | 日本語

このイメージには、rootユーザー向けのSSH公開鍵を配置する小さなレシピを含めています。

## レシピ

```text
recipes-core/ssh/root-authorized-keys/root-authorized-keys.bb
```

このレシピは以下へファイルをインストールします。

```text
/home/root/.ssh/authorized_keys
```

ファイル権限は `0600` です。

## ローカル鍵テンプレート

リポジトリにはテンプレートだけを含めています。

```text
recipes-core/ssh/root-authorized-keys/files/authorized_keys.example
```

ビルド前にコピーします。

```bash
cp recipes-core/ssh/root-authorized-keys/files/authorized_keys.example \
   recipes-core/ssh/root-authorized-keys/files/authorized_keys
```

その後、プレースホルダーを自分の公開鍵へ置き換えます。

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your-name@example
```

実際の `authorized_keys` はコミットしません。

## パスワードレスSSH

イメージが起動し、Wi-Fi接続が完了したら以下でログインします。

```bash
ssh root@<raspberry-pi-ip>
```

イメージに組み込んだ公開鍵に対応する秘密鍵でログインできる状態になります。

