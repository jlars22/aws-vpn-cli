# aws-vpn-cli

A CLI companion for the [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/). Uses your existing profiles and the OpenVPN binary bundled with the app.

<img src=".github/demo.png" alt="vpn interactive picker" width="420">

Stay in your terminal instead of clicking through the GUI. Scripts nicely too:

```bash
assume staging && vpn staging   # credentials + vpn in one go
```

## Install

Requires macOS and [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) with at least one profile configured.

```bash
brew install jlars22/tools/aws-vpn-cli
```

Run `vpn` — profiles are imported on first launch. Tab completion is available for zsh (restart your shell after installing).

## Usage

```console
$ vpn                   # interactive profile picker
$ vpn <profile>         # connect directly
$ vpn status            # show connection status
$ vpn disconnect        # disconnect
$ vpn list              # list available profiles
$ vpn import            # re-import profiles from AWS VPN Client
$ vpn logs              # tail the connection log
$ vpn setup-sudo        # skip password prompts (configures sudoers)
```

## How it works

SAML auth is handled by a local server that captures the SSO callback. The tunnel runs on the OpenVPN binary bundled with the AWS VPN Client.

> [!NOTE]
> Homebrew's OpenVPN doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities.

## Credits

Built on ideas from [aws-vpn-client](https://github.com/aws-vpn-client/aws-vpn-client).