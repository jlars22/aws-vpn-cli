<div align="center">

# aws-vpn-cli

A CLI wrapper for the [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/). Connect to your VPN without leaving the terminal.

Supports macOS and Linux.

<br>

<img src=".github/demo.gif" alt="aws-vpn-cli demo" width="600">

</div>

<br>

## Install

### Prerequisites

- [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) with at least one profile configured
- Python 3
- `sudo` access (for establishing the tunnel)

### Homebrew

```bash
brew install jlars22/tools/aws-vpn-cli
```

### Manual

```bash
git clone https://github.com/jlars22/aws-vpn-cli.git
ln -s "$(pwd)/aws-vpn-cli/vpn" ~/.local/bin/vpn
```

Make sure `~/.local/bin` is on your `PATH`.

## Usage

Most of the time you just run `vpn`. It shows an [fzf](https://github.com/junegunn/fzf) picker — select a profile to connect, select an active one to disconnect. Profiles are imported on first launch.

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

Multiple VPN connections are supported simultaneously — just run `vpn` again and pick another profile.

Tab completion is available for zsh (restart your shell after installing).

## How it works

Imports your existing AWS VPN Client profiles, starts a local SAML server on `127.0.0.1:35001`, initiates an OpenVPN handshake to get the SSO URL, opens your browser for authentication, then establishes the tunnel using the bundled `acvc-openvpn` binary with `sudo`. DNS is configured via `scutil` (macOS) or `resolvectl` (Linux).

No data leaves your machine beyond normal SSO/VPN traffic.

## Credits

Built on ideas from [aws-vpn-client](https://github.com/aws-vpn-client/aws-vpn-client).
