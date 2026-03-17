<p align="center">
  <h1 align="center">aws-vpn-cli</h1>
  <p align="center">
    <b>Connect to AWS Client VPN from your terminal. No GUI needed.</b>
  </p>
  <p align="center">
    <a href="#installation">Installation</a> &middot;
    <a href="#usage">Usage</a> &middot;
    <a href="#how-it-works">How it works</a>
  </p>
</p>

<br>

```
$ vpn import
==> Importing profiles from AWS VPN Client
  ✓ Production -> production
  ✓ Staging -> staging
  ✓ Development -> development

✓ 3 profile(s) imported

$ vpn staging
==> Starting SAML listener
==> Connecting to Staging
> Resolved cvpn-endpoint-xxx...amazonaws.com -> 3.78.110.52:443
> Getting SAML redirect URL...
==> Opening browser for SAML authentication
> Waiting for SAML response (up to 30s)...
✓ SAML authentication successful!
==> Establishing VPN tunnel
```

A simple CLI wrapper around the AWS VPN Client. It imports your existing connection profiles and lets you connect with a single command — handling the SAML authentication flow, browser redirect, and tunnel setup automatically.

## Installation

### Prerequisites

- **macOS** (uses `scutil` for DNS, `open` for browser)
- **[AWS VPN Client](https://aws.amazon.com/vpn/client-vpn-download/)** installed with at least one connection profile configured
- **[Go](https://go.dev/dl/)** 1.21+ (to build the SAML authentication server)

### Install

```bash
git clone https://github.com/jlars22/aws-vpn-cli.git
cd aws-vpn-cli
make install
```

This builds the SAML server, installs to `~/.local/share/aws-vpn-cli/`, and symlinks `vpn` into `/usr/local/bin` (requires sudo).

### Uninstall

```bash
make uninstall
```

## Usage

### Import profiles from AWS VPN Client

```bash
vpn import
```

Reads your existing connection profiles from the AWS VPN Client app. Run this once after installing, or again if you add new profiles in the GUI.

### List available profiles

```bash
vpn list
```

```
  development               Development (eu-central-1)
  production                Production (eu-central-1)
  staging                   Staging (eu-central-1)
```

### Connect

```bash
vpn staging
```

This will:
1. Start a local SAML authentication listener
2. Initiate the VPN handshake to get a SAML redirect URL
3. Open your browser for SSO login
4. Capture the SAML response and establish the tunnel

> [!NOTE]
> `sudo` is required to create the tunnel interface. You'll be prompted for your password.

### Check status

```bash
vpn status
```

```
✓ VPN is up (staging)
```

## How it works

The tool reuses the OpenVPN binary bundled inside the AWS VPN Client app and your existing connection profiles — it doesn't ship any VPN binaries or endpoint configurations.

The authentication flow mirrors what the AWS VPN Client GUI does under the hood:

1. **SAML redirect** — Connects to the VPN endpoint to get a SAML authentication URL
2. **Browser login** — Opens the URL in your default browser for SSO login
3. **Token capture** — A local HTTP server captures the SAML response
4. **Tunnel setup** — Establishes the OpenVPN tunnel with the SAML token, configures DNS via `scutil`

## Configuration

Profiles are stored in `~/.config/aws-vpn-cli/` after import. To re-import:

```bash
vpn import
```

To use a custom OpenVPN binary:

```bash
OVPN_BIN=/path/to/openvpn vpn staging
```

## License

MIT
