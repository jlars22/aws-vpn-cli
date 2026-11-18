# aws-vpn-cli

A bash CLI (`vpn`) wrapping the AWS VPN Client on macOS and Linux.

## Layout

- `vpn`: the whole CLI. Python snippets are inlined as `python3 -c` and heredocs, using the standard library only.
- `saml-server.py`: local SAML callback server on `127.0.0.1:35001`, legacy backend only.
- `route-up.sh`, `dns-down.sh`: OpenVPN hooks that set and restore DNS, legacy backend only.
- `_vpn` (zsh) and `vpn.bash` (bash): tab completion.

## Two backends

`BACKEND` is set near the top of `vpn`:

- `native`: macOS with AWS VPN Client 6+. Delegates to the client's bundled `aws-vpn-client` CLI. No sudo, no OpenVPN process of our own.
- `legacy`: AWS VPN Client 5.x and Linux. Runs the bundled `acvc-openvpn` under sudo, with `saml-server.py` for SSO.

A change to connect, disconnect, status, list, logs or import usually needs both paths.

## Checks

No test suite, and CI cannot make a real VPN connection. Before committing, run what `.github/workflows/lint.yml` runs:

```bash
shellcheck vpn vpn.bash *.sh
python3 -m py_compile saml-server.py
bash -n vpn
```

## Conventions

- Conventional commits (`feat:`, `fix:`, `docs:`, `chore:`, `ci:`). Release notes are drafted from them.
- A new command needs: `usage()`, the `case` dispatch at the bottom of `vpn`, `_vpn`, `vpn.bash`, and the usage block in `README.md`.
- Don't bump `VERSION` in feature PRs; the release does that. Releasing: `/release`.
- A change to the sudoers rules in `cmd_setup_sudo` breaks passwordless sudo for existing users until they redo the setup. Call it out in the PR so the release notes can say so.
