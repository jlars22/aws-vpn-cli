# aws-vpn-cli

A simple CLI alternative to the AWS VPN Client UI. Import your existing profiles and connect entirely from the terminal.

```console
$ vpn
VPN >
  dev          Development (eu-central-1)
> production   Production (eu-central-1) ● connected
  staging      Staging (eu-central-1)
```

Run `vpn` to open an interactive profile picker. Select a profile to connect, select the active one to disconnect. That's it.

You can also connect directly:

```console
$ vpn staging
==> Authenticating
==> Opening browser for SSO
✓ Authenticated
==> Establishing tunnel
✓ Connected to Staging
```

## Requirements

- macOS
- Python 3 (ships with macOS)
- [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) with at least one profile configured

## Install

```bash
brew install jlars22/tools/aws-vpn-cli
vpn
```

## Commands

| Command | |
|---|---|
| `vpn` | Interactive profile picker (connect, switch, or disconnect) |
| `vpn <profile>` | Connect directly to a profile |
| `vpn status` | Show connection status |
| `vpn disconnect` | Disconnect |
| `vpn list` | List available profiles |
| `vpn import` | Re-import profiles from AWS VPN Client |
| `vpn logs` | Tail the connection log |
| `vpn setup-sudo` | Skip password prompts (configures sudoers) |

Tab completion is available for zsh — restart your shell after installing.

## How does it work?

It reuses the OpenVPN binary that ships inside the AWS VPN Client app and your existing connection profiles — no separate OpenVPN install, no manual config. The SAML authentication flow is handled by a small Go server that captures the SSO callback from your browser.

> [!NOTE]
> Homebrew's OpenVPN doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities. That's why this uses the binary bundled with the AWS VPN Client, which is built against OpenSSL 3.0.
