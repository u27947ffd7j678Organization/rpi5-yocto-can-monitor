# Root authorized_keys

The image includes a small recipe that installs an SSH public key for the root user.

## Recipe

```text
recipes-core/ssh/root-authorized-keys/root-authorized-keys.bb
```

The recipe installs:

```text
/home/root/.ssh/authorized_keys
```

with mode `0600`.

## Local Key Template

The repository includes only a template:

```text
recipes-core/ssh/root-authorized-keys/files/authorized_keys.example
```

Copy it before building:

```bash
cp recipes-core/ssh/root-authorized-keys/files/authorized_keys.example \
   recipes-core/ssh/root-authorized-keys/files/authorized_keys
```

Then replace the placeholder with your public key:

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your-name@example
```

Do not commit the real `authorized_keys` file.

## Passwordless SSH

After the image boots and Wi-Fi is connected:

```bash
ssh root@<raspberry-pi-ip>
```

The login should use the private key corresponding to the public key installed in the image.

