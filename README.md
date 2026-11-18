<div align="center">

# aws-vpn-cli

*Connect to AWS Client VPN from your terminal*

[![Lint](https://img.shields.io/github/actions/workflow/status/jlars22/aws-vpn-cli/lint.yml?branch=main&style=flat-square&label=lint)](https://github.com/jlars22/aws-vpn-cli/actions/workflows/lint.yml)
[![Release](https://img.shields.io/github/v/release/jlars22/aws-vpn-cli?style=flat-square)](https://github.com/jlars22/aws-vpn-cli/releases)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)

[Features](#features) • [Install](#install) • [Usage](#usage) • [How it works](#how-it-works) • [Troubleshooting](#troubleshooting)

<img src=".github/demo.gif" alt="aws-vpn-cli demo" width="600">

</div>

A wrapper around the [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) that uses the profiles you already have and handles SSO in your browser, so you never have to open the client's window. Works on macOS and Linux.

## Features

- Imports your existing AWS VPN Client profiles on first run
- Interactive [fzf](https://github.com/junegunn/fzf) picker to connect and disconnect
- Several connections at once, with `vpn all` to connect to every profile
- Supports AWS VPN Client 6+ on macOS through its bundled `aws-vpn-client` CLI
- Optional passwordless `sudo` setup for older clients and Linux
- Tab completion for bash and zsh

## Install

### Prerequisites

- [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) with at least one profile configured
- Python 3
- `sudo` access to start the tunnel (not needed with AWS VPN Client 6+ on macOS)
- [fzf](https://github.com/junegunn/fzf), optional, for the interactive picker
- `musl` on Linux, to run the client's bundled OpenVPN binary (`sudo apt install musl` on Ubuntu/Debian)

### Homebrew

```bash
brew install jlars22/tools/aws-vpn-cli
```

Homebrew also sets up tab completion.

### Manual

```bash
git clone https://github.com/jlars22/aws-vpn-cli.git
ln -s "$(pwd)/aws-vpn-cli/vpn" ~/.local/bin/vpn
```

Make sure `~/.local/bin` is on your `PATH`. For tab completion:

```bash
# bash: add to ~/.bashrc
source /path/to/aws-vpn-cli/vpn.bash

# zsh: symlink into your fpath
ln -s /path/to/aws-vpn-cli/_vpn ~/.zsh/completions/_vpn
```

## Usage

Run `vpn` with no arguments. It shows a picker: select a profile to connect, or select a connected one to disconnect.

```console
$ vpn                       # interactive picker (connect or disconnect)
$ vpn [profile]             # connect (or disconnect if already connected)
$ vpn all                   # connect to all profiles one after another
$ vpn status                # show active connections
$ vpn disconnect [profile]  # disconnect (or pick if several are connected)
$ vpn disconnect all        # disconnect everything
$ vpn list                  # list available profiles
$ vpn import                # re-import profiles from AWS VPN Client
$ vpn logs [profile]        # tail the connection log
$ vpn setup-sudo            # skip password prompts (writes /etc/sudoers.d/aws-vpn-cli)
$ vpn --version             # print version
```

> [!TIP]
> Added or renamed a profile in AWS VPN Client? Run `vpn import` to pick up the change.

## How it works

`vpn` reads your AWS VPN Client profiles and stores its own copy in `~/.config/aws-vpn-cli`. How it connects depends on the client version.

**AWS VPN Client 6+ on macOS.** The client runs OpenVPN inside its own daemon and ships an `aws-vpn-client` CLI. `vpn` hands connect, disconnect and status to that CLI. The daemon handles SSO, the tunnel and DNS, and `vpn logs` follows its log in `/var/log/AWSVPNClient`.

**AWS VPN Client 5.x and Linux.** `vpn` starts a local SAML server on `127.0.0.1:35001` and begins an OpenVPN handshake to get the SSO URL. It then opens your browser to sign in and starts the tunnel with the client's bundled `acvc-openvpn` binary under `sudo`. DNS is set with `scutil` on macOS or `resolvectl` on Linux.

No data leaves your machine beyond normal SSO and VPN traffic.

## Troubleshooting

> [!IMPORTANT]
> Upgrading from 0.5.x with passwordless sudo set up? The sudo rules changed in 0.6.0. Run `sudo rm /etc/sudoers.d/aws-vpn-cli && vpn setup-sudo` once, or `vpn disconnect` will ask for your password.

- **"Port 35001 is already in use".** Another process holds the SAML callback port. Find and stop it with `lsof -ti :35001 | xargs kill`.
- **Asked for your password on every connect.** Run `vpn setup-sudo` once.
- **Something else.** Run `vpn logs [profile]` to see the connection log.

## Credits

Built on ideas from [aws-vpn-client](https://github.com/aws-vpn-client/aws-vpn-client).
