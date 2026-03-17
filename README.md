# aws-vpn-cli

Connect to AWS Client VPN from the terminal instead of the GUI app.

Imports your existing profiles from the AWS VPN Client and handles the SAML authentication flow — opens browser, captures the token, establishes the tunnel.

```
$ vpn import
==> Importing profiles from AWS VPN Client
  ✓ Production EU -> production-eu
  ✓ Staging -> staging

$ vpn staging
==> Connecting to Staging
> Resolved cvpn-endpoint-xxx...amazonaws.com -> 3.78.110.52:443
==> Opening browser for SAML authentication
✓ SAML authentication successful!
==> Establishing VPN tunnel

$ vpn status
✓ VPN is up (staging)
```

## Requirements

- macOS
- [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn-download/) with at least one profile configured
- [Go](https://go.dev/dl/) 1.21+

## Install

```bash
git clone https://github.com/jlars22/aws-vpn-cli.git
cd aws-vpn-cli
make install   # sudo for symlinking vpn to /usr/local/bin
vpn import
```

## Commands

| Command | |
|---|---|
| `vpn import` | Import profiles from AWS VPN Client |
| `vpn list` | List available profiles |
| `vpn <profile>` | Connect |
| `vpn status` | Show connection status |

## How does it work?

It uses the OpenVPN binary that ships inside the AWS VPN Client app — no separate OpenVPN install needed. The SAML flow is handled by a small Go server that listens for the SSO callback.

> [!NOTE]
> Homebrew's OpenVPN (2.7.x and 2.6.19) doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities. That's why this uses the binary bundled with the AWS VPN Client, which is built against OpenSSL 3.0.