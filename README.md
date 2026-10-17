# nix-config: nix configuration for mac machines

## Table of Contents

- [Architecture](#architecture)
  - [Layout](#layout)
  - [Configuration layers](#configuration-layers)
- [Install](#install)
  - [1. Install dependencies](#1-install-dependencies)
  - [2. Install nix](#2-install-nix)
  - [3. Clone this repository](#3-clone-this-repository)
  - [4. Create a machine config](#4-create-a-machine-config)
  - [5. Bootstrap the keys](#5-bootstrap-the-keys)
  - [6. Prepare ~/.config](#6-prepare-config)
  - [7. Build the configuration](#7-build-the-configuration)
  - [8. Deploy the configuration](#8-deploy-the-configuration)
  - [9. Manual setups and configurations](#9-manual-setups-and-configurations)
- [Common tasks](#common-tasks)
  - [Building and switching](#building-and-switching)
  - [Adding a new machine](#adding-a-new-machine)
  - [Adding a new user](#adding-a-new-user)
  - [Machine-specific overrides](#machine-specific-overrides)
  - [Updating inputs](#updating-inputs)
  - [Binary cache](#binary-cache)
- [AI tools](#ai-tools)
  - [MCP servers](#mcp-servers)
  - [Skills](#skills)
  - [GitHub MCP server for Claude Code](#github-mcp-server-for-claude-code)
- [Secrets](#secrets)
  - [Docker: GitHub Container Registry](#docker-github-container-registry)

## Architecture

### Layout

```
.
├─┬─ .github/workflows   # CI: eval, build, cache, weekly input updates (all auto-discovered)
├─┬─ apps                 # Scripts behind `nix run .#<app>` (build, switch, cache, ...)
├─┬─ brew                 # Homebrew configuration (shared brews/casks + machine extras)
│ ├── brews.nix           # Shared homebrew brews (all machines)
│ ├── casks.nix           # Shared homebrew casks (all machines)
│ └── default.nix         # Unions shared + machine-specific brews/casks
├─┬─ ci                   # CI secrets stub (empty .age placeholders for --override-input)
├─┬─ darwin               # System-level nix-darwin configuration
│ ├─┬─ modules            # System modules (nix, networking, security, secrets, fonts, ...)
│ ├─┬─ overlays           # Darwin-level option definitions (user.*, home.*, xdg.*)
│ └── default.nix         # Wires primaryUser, users.users, system settings
├─┬─ home                 # Shared home-manager configuration (all users)
│ ├─┬─ files              # Shared config files (lsd, wget, p10k, iterm2 plist)
│ ├─┬─ modules            # Shared HM modules (git, zsh, tmux, fzf, packages, ...)
│ └─┬─ overlays           # HM option definitions (ai.*, dock.*, user.*)
│   ├── ai.nix            # AI tools overlay: shared MCP servers + skills for Claude/Codex
│   ├─┬─ misc             # user.* option definitions
│   └─┬─ system           # dock.* option definitions
├─┬─ lib                  # Helper functions
│ └── mkDarwinSystem.nix  # Builds a darwin+HM config from a machine config path
├─┬─ machines             # Per-machine configuration (auto-discovered by flake.nix)
│ ├── macbook-pjan.nix    # Work Mac (L-FW3C6X79MN) — pieterjan.vandaele
│ └── icarus.nix          # Home Mac (Icarus) — pjan + nao
├─┬─ nixpkgs              # Nixpkgs overlays and extensions
├─┬─ users                # Per-user home-manager configuration
│ ├── default.nix         # User registry: maps system usernames → user module paths
│ ├─┬─ pjan              # pjan's HM config
│ │ ├── default.nix       # Identity, dock, imports ./modules
│ │ └─┬─ modules          # pjan-specific modules (ai, git signing, ssh, docker, ...)
│ └─┬─ nao               # nao's HM config
│   ├── default.nix       # Identity, imports ./modules
│   └─┬─ modules          # nao-specific modules (packages, ...)
├── flake.nix             # Flake: auto-discovers machines, wires overlays + mkDarwinSystem
└── README.md
```

### Configuration layers

Configuration is composed from multiple layers that merge together:

**System level (darwin):**

| Layer | Location | Scope |
|-------|----------|-------|
| Shared darwin modules | `darwin/modules/` | All machines |
| Darwin option definitions | `darwin/overlays/` | All machines |
| Machine-specific darwin modules | `machines/<hostname>.nix` → `darwin.extraModules` | One machine |

**User level (home-manager):**

| Layer | Location | Scope |
|-------|----------|-------|
| Shared HM modules | `home/modules/` | All users, all machines |
| HM option definitions | `home/overlays/` (ai, dock, user) | All users, all machines |
| Machine-specific HM modules | `machines/<hostname>.nix` → `home.extraModules` | All users on one machine |
| Per-user per-machine HM modules | `machines/<hostname>.nix` → `home.userModules.<user>` | One user on one machine |
| Per-user modules | `users/<name>/modules/` | One user, all machines |

Later layers can add to or override earlier ones (HM merges `home.packages`, `ai.mcpServers`, etc.; use `lib.mkForce` to override).

**Machine config** (`machines/<hostname>.nix`) is a plain attrset with:

```nix
{
  machine.hostname = null;           # networking.hostName (null = unset)
  machine.localHostName = "Icarus";  # used as the darwinConfigurations key
  machine.computerName = "Icarus";
  machine.dns = [ ];
  machine.primaryUser = "pjan";      # admin user (secrets, homebrew, system.primaryUser)
  machine.users = [ "pjan" "nao" ];  # all users on this machine

  nix.sslCertFile = null;            # Zscaler CA bundle path, or null
  brew = {
    enable = false;
    cleanup = "zap";
    brews = [ ];                     # machine-specific brews (unioned with brew/brews.nix)
    casks = [ ];                     # machine-specific casks (unioned with brew/casks.nix)
  };

  home.extraModules = [ ];           # HM modules for all users on this machine
  home.userModules.<user> = [ ];     # HM modules for one user on this machine
  darwin.extraModules = [ ];         # darwin modules for this machine
}
```

## Install

### 1. Install dependencies

```sh
xcode-select --install
```

### 2. Install nix

We'll be using the [Lix installer](https://lix.systems/install/) with its defaults (multi-user daemon, flakes enabled).
It only bootstraps: after the first deploy, nix-darwin provides the Nix daemon and CLI (see the cleanup in step 8).

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

### 3. Clone this repository

The repository is public, so clone it over HTTPS (no keys needed yet):

```sh
git clone https://github.com/pjan/nix-config.git
cd nix-config
```

### 4. Create a machine config

Create a file in `machines/` for the new machine. The filename doesn't matter;
`machine.localHostName` is used as the `darwinConfigurations` key and must match what
`scutil --get LocalHostName` returns on the machine:

```sh
scutil --get LocalHostName   # e.g. "MyMac"
cp machines/icarus.nix machines/my-mac.nix
vi machines/my-mac.nix       # set localHostName, primaryUser, users, etc.
```

Add the user(s) to `users/default.nix` if they don't exist yet (see
[Adding a new user](#adding-a-new-user)).

### 5. Bootstrap the keys

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

### 6. Prepare ~/.config

Home Manager writes into `~/.config`, which must be a directory owned by you. Replace a leftover symlink or file,
create the directory if needed, and fix its ownership if an earlier `sudo` command created it as root. An existing
directory and its contents are kept.

```sh
if [ -L ~/.config ] || [ -f ~/.config ]; then sudo rm ~/.config; fi
mkdir -p ~/.config && sudo chown "$(id -un)" ~/.config
```

### 7. Build the configuration

You can ensure the build works before deploying the configuration. To do so, execute:

```sh
nix run .#build
```

### 8. Deploy the configuration

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

### 9. Manual setups and configurations

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

## Common tasks

### Building and switching

The app scripts auto-detect the current machine via `scutil --get LocalHostName`.
You can also pass a hostname explicitly to build another machine's config:

```sh
nix run .#build-switch                                  # build and activate this machine
nix run .#build -- --keep-result && nix run .#switch    # build first, activate later
nix run .#build -- Icarus                               # build Icarus config from any machine
```

Builds use `path:.`, so uncommitted and git-ignored files are included.

### Adding a new machine

1. Create `machines/<name>.nix` with the machine config (see
   [Configuration layers](#configuration-layers) for the schema).
   Set `machine.localHostName` to match the output of `scutil --get LocalHostName` on that machine.
2. That's it. The flake auto-discovers all `.nix` files in `machines/` and CI auto-discovers
   all `darwinConfigurations` via `nix eval`.

### Adding a new user

1. Create `users/<name>/default.nix` with identity and `home.stateVersion`.
2. Create `users/<name>/modules/packages.nix` (can be an empty list).
3. Add the username → module path mapping in `users/default.nix`.
4. Add the username to `machine.users` in the relevant machine config(s).

### Machine-specific overrides

Use the `home.extraModules`, `home.userModules`, and `darwin.extraModules` fields in
`machines/<hostname>.nix`:

```nix
{
  # Extra HM modules for all users on this machine.
  home.extraModules = [
    ({ lib, pkgs, ... }: {
      home.packages = [ pkgs.salesforce-cli ];
    })
  ];

  # Extra HM modules for one user on this machine.
  home.userModules."pieterjan.vandaele" = [
    ({ ... }: {
      ai.mcpServers.glean = { url = "https://example.com/mcp/default"; };
    })
  ];

  # Extra darwin modules for this machine.
  darwin.extraModules = [
    ({ ... }: {
      system.defaults.dock.autohide = false;
    })
  ];
}
```

### Darwin-level local overrides

`darwin/overrides.nix` is git-ignored and imported when present, for darwin-level settings that
only apply to one machine (e.g., system defaults tweaks). For HM-level overrides, use
`home.extraModules` or `home.userModules` in the machine config instead.

### Formatting

```sh
nix fmt                              # nixfmt over all tracked .nix files
```

### Rollback

```sh
nix run .#rollback                   # list generations and switch to a previous one
```

### Updating inputs

The weekly `Update Inputs` workflow updates all flake inputs except the homebrew taps, builds
all machine configs on macOS, pushes them to the binary cache, and only then opens a
`chore(flake): update inputs` PR. Merge it, pull, and run `nix run .#build-switch`: everything
comes from the cache.

To update manually:

```sh
nix flake update nixpkgs                         # update one input (omit the name for all)
```

### Binary cache

Builds are cached in the `io-vandaele-nix-cache` GCS bucket (S3 API) and signed with the key in
`/etc/nix/secret-key`; the public key is trusted in `darwin/modules/nix.nix`.

- CI: the `Build and Cache` workflow builds and pushes all machine configs on every `flake.lock`
  change on `main` (and on manual dispatch); `Update Inputs` does the same before opening its PR.
- Locally: `nix run .#build-cache` builds, signs and pushes; `nix run .#cache` pushes an existing
  `./result`.

## AI tools

The `ai.*` options (defined in `home/overlays/ai.nix`) let you declare MCP servers and skills
once, and they are automatically configured for both Claude Code and Codex.

Tool-specific settings (plugins, model, permissions) go directly in
`programs.claude-code.settings` / `programs.codex.settings` in the user's modules.

### MCP servers

```nix
# users/pjan/modules/ai.nix — shared across all machines
ai.mcpServers = {
  github = {
    url = "https://api.githubcopilot.com/mcp/";
    bearerTokenEnvVar = "GITHUB_PAT_TOKEN";
  };
  chrome-devtools = {
    command = "chrome-devtools-mcp";
  };
};
```

Machine-specific MCP servers go in `home.extraModules` or `home.userModules` in the machine config:

```nix
# machines/macbook-pjan.nix — only on this machine
home.extraModules = [
  ({ ... }: {
    ai.mcpServers.glean = { url = "https://example.com/mcp/default"; };
  })
];
```

The overlay maps each server to both tools: Claude Code receives the definition as-is;
Codex gets `bearerTokenEnvVar` renamed to `bearer_token_env_var`. Stdio servers
(`command`/`args`/`env`) are identical for both tools.

### Skills

```nix
ai.skills = {
  rust = ./skills/rust;          # path to a skill directory
  reverse-engineer-anything = pkgs.rea-agents.skill;  # skill shipped with a package
  pdf = ''
    # PDF Processing
    Use pdfplumber to extract text from PDFs.
  '';
};
```

Skills are deployed to `~/.claude/skills/<name>/` and `~/.codex/skills/<name>/`
(via the native `programs.claude-code.skills` / `programs.codex.skills` options).

### GitHub MCP server for Claude Code

The GitHub MCP server token for Claude Code is not exported in the shell environment.
Claude Code reads it through a `headersHelper`, `~/.local/bin/github-mcp-headers`, which
prints the `Authorization` header from the agenix secret `/run/agenix/github-mcp-token`.
This helper is provisioned automatically by `home/modules/github-mcp.nix` on machines
where the `github-mcp-token` secret is configured.

## Secrets

Secrets are managed with [agenix](https://github.com/ryantm/agenix). The encrypted `.age` files live
in the private `pjan/nix-secrets` repository (the `secrets` flake input, fetched over SSH) and are
decrypted during activation with the identity `~/.ssh/id_ed25519_agenix`. Both that identity and the deploy key
that reads `pjan/nix-secrets` on a new machine are kept in the `Bootstrap` vault in 1Password and restored by
`nix run .#bootstrap` (see Install, step 5).

The secrets and where they are installed are declared in `darwin/modules/secrets.nix`, owned by the
machine's `primaryUser`. To edit a secret, use `agenix -e <name>.age` in a checkout of `nix-secrets`
(`nix develop` in this repo provides `agenix`). CI builds use `ci/secrets-stub` instead, which needs
an empty placeholder for every secret.

### Docker: GitHub Container Registry

Docker gets the `ghcr.io` token from the credential helper `docker-credential-agenix`, which reads the agenix secret
`/run/agenix/ghcr-token`; activation sets `"credHelpers": {"ghcr.io": "agenix"}` in `~/.docker/config.json` and
removes any plaintext `ghcr.io` entry. `docker login ghcr.io` is not needed (the helper refuses to store credentials).
To rotate the token, update it in 1Password and `nix-secrets` (`agenix -e ghcr-token.age`), then switch.
