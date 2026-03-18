# aws-vpn-cli

A CLI companion for the [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/). Uses your existing profiles and the OpenVPN binary bundled with the app.

<img src=".github/demo.png" alt="vpn interactive picker" width="420">

Stay in your terminal instead of clicking through the GUI.

## Install

Requires [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) with at least one profile configured, and Python 3.

```bash
brew install jlars22/tools/aws-vpn-cli
```

Or clone the repo and symlink `vpn` onto your PATH manually.

Run `vpn` — profiles are imported on first launch. Tab completion is available for zsh (restart your shell after installing).

## Usage

```console
$ vpn                       # interactive picker (connect or disconnect)
$ vpn [profile]             # connect (or disconnect if already connected)
$ vpn status                # show active connections
$ vpn disconnect [profile]  # disconnect (or select if multiple)
$ vpn list                  # list available profiles
$ vpn import                # re-import profiles from AWS VPN Client
$ vpn logs [profile]        # tail the connection log
$ vpn setup-sudo            # skip password prompts (configures sudoers)
```

Multiple VPN connections are supported simultaneously.

> [!TIP]
> When using multiple VPNs, DNS queries default to the first connection's DNS server. To route DNS per domain, configure your OS resolver — search for `/etc/resolver` on macOS or `resolvectl` / NetworkManager dispatcher scripts on Linux.

## How it works

SAML auth is handled by a local Python server that captures the SSO callback. The tunnel runs on the OpenVPN binary bundled with the AWS VPN Client.

> [!NOTE]
> Homebrew's OpenVPN doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities.

## Credits

Built on ideas from [aws-vpn-client](https://github.com/aws-vpn-client/aws-vpn-client).
