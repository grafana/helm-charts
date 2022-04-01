# Internal documentation

This document has information relevant to the maintainers of this repository.
End-user technical documentation should live within the charts themselves or in the `gh-pages` branch.

## Package signing

Release automation signs Helm chart releases using a GPG key stored in a [GitHub Actions secret](https://github.com/grafana/helm-charts/settings/secrets/actions).
Only repository administrators have permissions to update secrets.
Release automation uses the `GPG_KEY_BASE64` secret to sign the packages.

The `GPG_KEY_BASE64` is a base64 encoded GPG key.
It expires on 2023-03-30.

Grafana Labs employees may access the private key using from the company 1password.

Grafana Labs employees can extend the expiry of the private key using the `gpg` command line tool.

1. Write the contents of the `Loki Helm GPG Key` 1password secret into a file.

1. Import the key into a separate keyring.

   ```console
   $ gpg --no-default-keyring --keyring ~/.gnupg/helm-charts.gpg --import <PATH TO GPG KEY>
   gpg: key 7054A9559D3CFB0B: public key "Grafana Loki <loki-team@googlegroups.com>" imported
   gpg: key 7054A9559D3CFB0B: secret key imported
   gpg: Total number processed: 1
   gpg:               imported: 1
   gpg:       secret keys read: 1
   gpg:  secret keys unchanged: 1
   ```

1. Run the `gpg` interactive prompt to edit the 'Grafana Loki' key.

   ```console
   $ gpg --no-default-keyring --keyring ~/.gnupg/helm-charts.gpg --edit-key 'Grafana Loki'
   gpg (GnuPG) 2.3.4; Copyright (C) 2021 Free Software Foundation, Inc.
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.

   Secret key is available.

   sec  rsa2048/7054A9559D3CFB0B
        created: 2020-03-29  expires: 2023-03-30  usage: SC
        trust: unknown       validity: ultimate
   ssb  rsa2048/4A6B2462555868C7
        created: 2020-03-29  expires: 2023-03-30  usage: E
   [ultimate] (1). Grafana Loki <loki-team@googlegroups.com>

   gpg>
   ```

1. At the `gpg` interactive prompt, run the `expire` command and follow the prompt to extend expiry.

   ```console
   gpg> expire
   Changing expiration time for the primary key.
   Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
   Key is valid for? <VALIDITY PERIOD>
   ```

1. At the `gpg` interactive prompt, select the subkey.

   ```console
   gpg> key 1
   sec  rsa2048/7054A9559D3CFB0B
       created: 2020-03-29  expires: 2023-04-01  usage: SC
       trust: unknown       validity: ultimate
   ssb* rsa2048/4A6B2462555868C7
       created: 2020-03-29  expires: 2023-03-30  usage: E
   [ultimate] (1). Grafana Loki <loki-team@googlegroups.com>
   ```

1. At the `gpg` interactive prompt, and with the subkey selected, run the `expire` command and follow the prompt to extend expiry of the subkey.

   ```console
   gpg> expire
   Changing expiration time for the primary key.
   Please specify how long the key should be valid.
        0 = key does not expire
     <n>  = key expires in n days
     <n>w = key expires in n weeks
     <n>m = key expires in n months
     <n>y = key expires in n years
   Key is valid for? <VALIDITY PERIOD>
   ```

1. At the `gpg` interactive prompt, run the `save` command to save changes and quit the program.

   ```console
   gpg> save
   ```

1. Base64 encode the keyring, placing the result into your clipboard.

   ```console
   $ base64 ~/.gnupg/helm-charts.gpg | xclip -selection clipboard -i
   ​
   ```

1. Update the `GPG_KEY_BASE64` GitHub Actions secret with the contents of your clipboard.

1. Export the private key to your clipboard.

   ```console
   $ gpg --no-default-keyring --keyring ~/helm-charts.gpg --export -a | xclip -selection clipboard -i
   ​​
   ```

1. Update the `Loki Helm GPG Key` secret in 1password with the contents of your clipboard.
