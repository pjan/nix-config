# nix-config: nix configuration for mac machines

## Table of Contents

- [Layout](#layout)
- [Install](#install)
  - [1. Install dependencies](#1-install-dependencies)
  - [2. Install nix](#2-install-nix)
  - [3. Clone this repository and configure with variables](#3-clone-this-repository-and-configure-with-variables)
  - [4. Bootstrap the keys](#4-bootstrap-the-keys)
  - [5. Prepare ~/.config](#5-prepare-config)
  - [6. Build the configuration](#6-build-the-configuration)
  - [7. Deploy the configuration](#7-deploy-the-configuration)
  - [8. Manual setups and configurations](#8-manual-setups-and-configurations)
- [Updating the configuration](#updating-the-configuration)
  - [Building and switching](#building-and-switching)
  - [Updating inputs](#updating-inputs)
  - [Binary cache](#binary-cache)
  - [Machine-local overrides](#machine-local-overrides)
- [Secrets](#secrets)

## Layout

```
.
├─┬─ .github/workflows # CI: eval check, weekly input updates, build and push to the binary cache
├─┬─ apps              # Scripts behind `nix run .#<app>` (build, switch, cache, ...)
├─┬─ brew              # Top folder with homebrew configuration
│ ├── brews.nix        # List of homebrew brews
│ ├── casks.nix        # List of homebrew casks
│ └── default.nix
├─┬─ darwin            # Top folder with nix-darwin configuration
│ ├─┬─ modules         # Folder with all the module configurations
│ │ └─ ...
│ ├─┬─ overlays        # Folder with nix-darwin extensions and overlays
│ │ └─ ...
│ └── default.nix
├─┬─ home              # Top folder with home-manager configuration
│ ├─┬─ files           # Folder with all the (template) files used
│ │ └─ ...
│ ├─┬─ modules         # Folder with all the module configurations
│ │ └─ ...
│ ├─┬─ overlays        # Folder with nix-darwin extensions and overlays
│ │ └─ ...
│ ├─┬─ packages        # Folder with configuration for packages to be installed
│ │ └─ ...
│ └── default.nix
├─┬─ nixpkgs           # Top folder for all nixpkgs configurations
│ ├─┬─ overlays        # Folder for all the nixpkgs overlays and extentions
│ │ └─ ...
│ └── ...
├─┬─ ci                # Stub config.nix and secrets used by CI builds
├── config.nix         # Machine/user variables (username, hostname, brew, ...)
├── flake.nix          # The flake file for this repo
└── README.md          # This file
```

## Install

### 1. Install dependencies

```sh
xcode-select --install
```

### 2. Install nix

We'll be using the [Lix installer](https://lix.systems/install/) with its defaults (multi-user daemon, flakes enabled).
It only bootstraps: after the first deploy, nix-darwin provides the Nix daemon and CLI (see the cleanup in step 7).

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

### 3. Clone this repository and configure with variables

The repository is public, so clone it over HTTPS (no keys needed yet). Change directory to where you want to store
the repo locally, and clone it:

```sh
git clone https://github.com/pjan/nix-config.git
```

Once the repo is cloned, change directory into it, and edit the `config.nix` file with the variables you want set.
`networking.dns` is optional: leave it out (or `[ ]`) to use the DNS servers from DHCP/VPN, or list fixed servers
such as `[ "8.8.8.8" "8.8.4.4" ]`.

```sh
cd nix-config && vi ./config.nix
```

You don't want those changes to be tracked or committed to the repo, which you can do by updating the repo index to assume no changes ever happen to the file

```sh
git update-index --assume-unchanged ./config.nix
```

### 4. Bootstrap the keys

The first build needs two SSH keys, kept in the `Bootstrap` vault in 1Password: a read-only deploy key for the
private `pjan/nix-secrets` repository (the `secrets` flake input) and the agenix identity that decrypts the secrets
during activation. Restore them with:

```sh
nix run .#bootstrap
```

It signs in with the 1Password CLI only, so the 1Password app isn't needed yet; have your sign-in address, email,
Secret Key and password ready. It adds GitHub's host keys to `~/.ssh/known_hosts`, writes
`~/.ssh/id_ed25519_agenix` and `~/.ssh/id_ed25519` (the deploy key), checks both against their expected fingerprints,
and verifies that `pjan/nix-secrets` is readable. It is safe to re-run, and never overwrites an existing, different
key.

### 5. Prepare ~/.config

Home Manager writes into `~/.config`, which must be a directory owned by you. Replace a leftover symlink or file,
create the directory if needed, and fix its ownership if an earlier `sudo` command created it as root. An existing
directory and its contents are kept.

```sh
if [ -L ~/.config ] || [ -f ~/.config ]; then sudo rm ~/.config; fi
mkdir -p ~/.config && sudo chown "$(id -un)" ~/.config
```

### 6. Build the configuration

You can ensure the build works before deploying the configuration. To do so, execute:

```sh
nix run .#build
```

### 7. Deploy the configuration

Finally, update the system by deploying the configuration:

```sh
nix run .#build-switch
```

From now on nix-darwin provides Nix. Open a new terminal, then remove what the installer left behind: the Lix
package in the default profile, and the installer's boot-time repair hook (it waits for `/nix/lix-installer`, which
the installer doesn't keep). Keep `/nix/nix-installer` and `/nix/receipt.json`; they are needed to uninstall Nix.

```sh
sudo /run/current-system/sw/bin/nix-env -p /nix/var/nix/profiles/default -e lix
sudo launchctl bootout system/systems.lix.nix-installer.nix-hook
sudo rm /Library/LaunchDaemons/systems.lix.nix-installer.nix-hook.plist
```

Once your own GitHub key works over SSH on this machine (`ssh -T git@github.com`), push over SSH and remove the
bootstrap deploy key. Keep it until then: later builds still fetch `pjan/nix-secrets` with it.

```sh
git remote set-url --push origin git@github.com:pjan/nix-config.git
rm ~/.ssh/id_ed25519
```

### 8. Manual setups and configurations

Some of the apps that have been installed require to be started, get permissions granted and/or configured manually.

Configure NPM so the global install works

```sh
npm set prefix ~/.local/lib
```

- iterm2: preferences > settings > load settings from `~/.config/iterm2/`, saving changes manually (but don't press save)
- App Store: Download apps
- 1password: login, enable command line cli
- Chrome: login
- ExpressVPN (vpn): login
- Hyperkey (a hyperkey): config, start at login
- Ice (menu bar manager): config, start at login
- Stats (menu bar stats): start at login
- Alfred (app launcher): license, install automation tasks, replace default spotlight with alfred, theme, start at login, workflows
- Rectangle pro (tiling window manager): license, start at login
- Rocket (emoji expansion): start at login
- Syncthing: On synthing bookmark in chrome - configure by adding folders and devices
- Tailscale (vpn & networking): login
- Tidal: login

Alfred workflow for expressvpn

```sh
npm install --global alfred-expressvpn
```

## Updating the configuration

### Building and switching

```sh
nix run .#build-switch                           # build and activate in one go
nix run .#build -- --keep-result && nix run .#switch   # or: build first, activate later
```

Builds use `path:.`, so uncommitted and git-ignored files (such as the overrides below) are included.

### Updating inputs

The weekly `Update Inputs` workflow updates all flake inputs except the homebrew taps, builds the
system on macOS, pushes it to the binary cache, and only then opens a `chore(flake): update inputs`
PR. Merge it, pull, and run `nix run .#build-switch`: everything comes from the cache.

To update manually, or to preview an update without touching `flake.lock`:

```sh
nix flake update nixpkgs                         # update one input (omit the name for all)
nix flake update --output-lock-file /tmp/flake.lock.new
nix build '.#darwinConfigurations.aarch64-darwin.system' --dry-run \
  --reference-lock-file /tmp/flake.lock.new --no-write-lock-file
```

### Binary cache

Builds are cached in the `io-vandaele-nix-cache` GCS bucket (S3 API) and signed with the key in
`/etc/nix/secret-key`; the public key is trusted in `darwin/modules/nix.nix`.

- CI: the `Build and Cache` workflow builds and pushes on every `flake.lock` change on `main`
  (and on manual dispatch); `Update Inputs` does the same before opening its PR.
- Locally: `nix run .#build-cache` builds, signs and pushes; `nix run .#cache` pushes an existing
  `./result`. CI builds with `ci/config-stub.nix`, so packages that only appear in machine-local
  overrides are not cached by CI; push those with `build-cache`.

### Machine-local overrides

`darwin/overrides.nix` and `home/overrides.nix` are git-ignored and imported when present, for
settings that only apply to one machine (extra packages, aliases, ...).

## Secrets

Secrets are managed with [agenix](https://github.com/ryantm/agenix). The encrypted `.age` files live
in the private `pjan/nix-secrets` repository (the `secrets` flake input, fetched over SSH) and are
decrypted during activation with the identity `~/.ssh/id_ed25519_agenix`. Both that identity and the deploy key
that reads `pjan/nix-secrets` on a new machine are kept in the `Bootstrap` vault in 1Password and restored by
`nix run .#bootstrap` (see Install, step 4).

The secrets and where they are installed are declared in `darwin/modules/secrets.nix`: the AWS-style
credentials for the binary cache (user and nix daemon), the cache signing key pair, the rclone
service account, and the GitHub token for Claude Code (below). To edit a secret, use `agenix -e <name>.age` in a
checkout of `nix-secrets` (`nix develop` in this repo provides `agenix`). CI builds use `ci/secrets-stub` instead,
which needs an empty placeholder for every secret.

### GitHub MCP server for Claude Code

The token is not exported in the shell environment. Claude Code reads it through a `headersHelper`,
`~/.local/bin/github-mcp-headers`, which prints the `Authorization` header from the agenix secret
`/run/agenix/github-mcp-token`. Register the server once per machine, and turn off the `github` plugin from
`claude-plugins-official` (`/plugin`), which expects the token in `GITHUB_PERSONAL_ACCESS_TOKEN` instead:

```sh
claude mcp add-json --scope user github \
  "{\"type\":\"http\",\"url\":\"https://api.githubcopilot.com/mcp/\",\"headersHelper\":\"$HOME/.local/bin/github-mcp-headers\"}"
```

Check with `/mcp` in a new Claude session that `github` is connected.

### Docker: GitHub Container Registry

Docker gets the `ghcr.io` token from the credential helper `docker-credential-agenix`, which reads the agenix secret
`/run/agenix/ghcr-token`; activation sets `"credHelpers": {"ghcr.io": "agenix"}` in `~/.docker/config.json` and
removes any plaintext `ghcr.io` entry. `docker login ghcr.io` is not needed (the helper refuses to store credentials).
To rotate the token, update it in 1Password and `nix-secrets` (`agenix -e ghcr-token.age`), then switch.
