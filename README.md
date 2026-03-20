<div align="center">

# aws-vpn-cli

A CLI wrapper for the [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/). Connect to your VPN without leaving the terminal.

<br>

<img src=".github/demo.gif" alt="aws-vpn-cli demo" width="600">

</div>

<br>

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

1. **Profile import** — reads your existing AWS VPN Client profiles and extracts the `.ovpn` configs
2. **SAML auth** — starts a local HTTP server on `127.0.0.1:35001`, initiates an OpenVPN handshake with dummy credentials, and receives a SAML SSO URL from the gateway
3. **Browser SSO** — opens the URL in your default browser; after you authenticate, the IdP posts the SAML response back to the local server
4. **Tunnel** — uses the SAML token to start the bundled `acvc-openvpn` binary as a background daemon with `sudo`, then configures DNS via `scutil` (macOS) or `resolvectl` (Linux)

The tool only talks to `127.0.0.1` and your VPN gateway — no data leaves your machine beyond the normal SSO/VPN traffic.

> [!NOTE]
> Homebrew's OpenVPN doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `Port 35001 is already in use` | Kill the process: `lsof -ti :35001 \| xargs kill` |
| SAML authentication times out | Check that your browser completed the SSO flow within 30 seconds |
| DNS not resolving after connect | Run `vpn logs <profile>` — look for `VPN DNS configured`. If missing, the server didn't push DNS options |
| DNS not restored after disconnect | Run `sudo scutil --dns` (macOS) or `resolvectl status` (Linux) and remove stale entries manually |
| `sudo: a password is required` | Run `vpn setup-sudo` to configure passwordless sudo |
| Stale connection shown in `vpn status` | The PID file outlived the process — `vpn disconnect <profile>` will clean it up |

## Credits

Built on ideas from [aws-vpn-client](https://github.com/aws-vpn-client/aws-vpn-client).
