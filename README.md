# aws-vpn-cli

I got tired of the AWS VPN Client UI so I built this. It lets you connect to AWS Client VPN entirely from the terminal — just import your existing profiles from the AWS VPN Client app and go.

```console
$ vpn import
==> Importing profiles from AWS VPN Client
  ✓ Production EU -> production-eu
  ✓ Staging -> staging
✓ 2 profile(s) imported

$ vpn staging
==> Connecting to Staging
==> Opening browser for SAML authentication
✓ SAML authentication successful!
✓ Connected to Staging

$ vpn status
✓ VPN is up (staging) — 03:42

$ vpn disconnect
==> Disconnecting from staging
✓ Disconnected
```

## Requirements

- macOS
- [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn-download/) with at least one profile configured

## Install

```bash
brew tap jlars22/tools
brew install aws-vpn-cli
vpn import
```

<details>
<summary>Alternative: install from source</summary>

Requires [Go](https://go.dev/dl/) 1.21+.

```bash
git clone https://github.com/jlars22/aws-vpn-cli.git
cd aws-vpn-cli
make install   # sudo for symlinking vpn to /usr/local/bin
vpn import
```

</details>

## Commands

| Command | |
|---|---|
| `vpn import` | Import profiles from AWS VPN Client |
| `vpn list` | List available profiles |
| `vpn <profile>` | Connect (runs in background) |
| `vpn status` | Show connection status |
| `vpn switch <profile>` | Disconnect and reconnect to a different profile |
| `vpn disconnect` | Disconnect |
| `vpn logs` | Tail the connection log |

Tab completion is available for zsh — restart your shell after installing.

## How does it work?

It reuses the OpenVPN binary that ships inside the AWS VPN Client app and your existing connection profiles — no separate OpenVPN install, no manual config. The SAML authentication flow is handled by a small Go server that captures the SSO callback from your browser.

> [!NOTE]
> Homebrew's OpenVPN doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities. That's why this uses the binary bundled with the AWS VPN Client, which is built against OpenSSL 3.0.
