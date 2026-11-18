---
name: release
description: Cut a new aws-vpn-cli release - bump VERSION, tag, publish the GitHub release, and update the Homebrew formula in jlars22/homebrew-tools. Use when asked to release, ship, publish or tag a new version.
---

# Release aws-vpn-cli

Every step below is outward-facing. Show the user the version and the release notes, and wait for their go before step 4.

## 1. Check the starting point

- On `main`, clean tree, up to date with `origin/main`.
- `gh run list -b main -L 1` shows the latest Lint run passed.
- `git log --oneline $(git describe --tags --abbrev=0)..HEAD` lists what goes out. If it holds only `docs:`, `chore:` or `ci:` commits, there is nothing to release. Say so and stop.

## 2. Pick the version

Semver, still pre-1.0: any `feat:` bumps the minor (0.6.0 → 0.7.0); only `fix:` bumps the patch (0.6.0 → 0.6.1). The current version is `VERSION="..."` near the top of `vpn`.

## 3. Draft the release notes

Match earlier releases (`gh release view <last tag>`):

```markdown
### Features

- **<command or platform>**: what changed, from the user's side. (#PR, thanks @author)

### Bug Fixes

- **<command>**: what was broken and what happens now. (#PR, thanks @author)
```

Add an `### Upgrading` section whenever users must act after upgrading, such as re-running `vpn setup-sudo` when the sudoers rules change. Credit external contributors with their GitHub login.

## 4. Bump, tag, release

```bash
sed -i '' 's/^VERSION="OLD"$/VERSION="NEW"/' vpn   # GNU sed: drop the ''
./vpn --version                                    # must print NEW
git commit -am "chore: bump version to NEW"
git push origin main
git tag -a vNEW -m "vNEW: <one-line summary>"      # annotated; a lightweight tag fails here
git push origin vNEW
gh release create vNEW --title vNEW --notes-file <notes.md> --latest
```

## 5. Update the Homebrew formula

The formula lives in a separate repo. Nothing in CI updates it, so skipping this means `brew upgrade` never sees the release.

```bash
sha=$(curl -sL https://github.com/jlars22/aws-vpn-cli/archive/refs/tags/vNEW.tar.gz | shasum -a 256 | cut -d' ' -f1)
gh repo clone jlars22/homebrew-tools <tmpdir>
# in Formula/aws-vpn-cli.rb: url -> tags/vNEW.tar.gz, sha256 -> $sha
git -C <tmpdir> commit -am "aws-vpn-cli NEW" && git -C <tmpdir> push
```

If the release adds a file the formula must install (next to `vpn`, `saml-server.py`, `route-up.sh`, `dns-down.sh`), add it to `def install` in the same commit.

## 6. Verify

```bash
brew update && brew upgrade jlars22/tools/aws-vpn-cli   # or brew install on a fresh machine
vpn --version                                            # prints NEW
```

Report the release URL and the tap commit.
