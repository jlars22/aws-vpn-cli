# aws-vpn-cli

Connect to AWS Client VPN entirely from the terminal. No separate OpenVPN install, no manual config — just `vpn`.

<img src=".github/demo.png" alt="vpn interactive picker" width="420">

## Highlights

- **Zero config** — imports profiles directly from the AWS VPN Client app
- **Interactive picker** — fuzzy-search your profiles with fzf
- **One command** — `vpn` to connect, switch, or disconnect
- **No extra OpenVPN** — reuses the binary bundled with AWS VPN Client (avoids OpenSSL 3.6 TLS incompatibilities with Homebrew's OpenVPN)
- **SAML/SSO** — opens your browser, captures the callback, done

## Install

Requires macOS and [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn/) with at least one profile configured.

```bash
brew install jlars22/tools/aws-vpn-cli
```

Then just run `vpn` — it will import your profiles on first launch.

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

Tab completion is available for zsh — restart your shell after installing.

## How it works

The SAML authentication flow is handled by a small Go server that captures the SSO callback from your browser. The connection itself uses the OpenVPN binary that ships inside the AWS VPN Client app, so there's nothing extra to install or configure.

> [!NOTE]
> Homebrew's OpenVPN doesn't work with AWS Client VPN due to OpenSSL 3.6 TLS incompatibilities. That's why this uses the binary bundled with the AWS VPN Client, which is built against OpenSSL 3.0.

## Credits

Built on ideas from [aws-vpn-client](https://github.com/aws-vpn-client/aws-vpn-client).