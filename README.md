# nix-config: nix configuration for mac machines

## Table of Contents

- [Layout](#layout)
- [Install](#install)
  - [1. Install dependencies](#1-install-dependencies)
  - [2. Install nix](#2-install-nix)
  - [3. Install keys](#3-install-keys)
  - [4. Clone this repository](#4-clone-this-repository)
  - [5. Make apps executable](#5-make-apps-executable)
  - [6. Build the configuration](#6-build-the-configuration)
  - [7. Deploy the configuration](#7-deploy-the-configuration)

## Layout

```
.
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
├── flake.nix          # The flake file for this repo
└── README.md          # This file
```

## Install

### 1. Install dependencies

```sh
xcode-select --install
```

### 2. Install nix

We'll be using the [Determinate Systems installer](https://zero-to-nix.com/concepts/nix-installer).

> [!IMPORTANT]
>
> Make sure you answer _No_ when the installer asks if you want to install Determinate Nix, as it [conflicts with nix-darwin](https://github.com/dustinlyons/nixos-config/issues/146).

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. Install keys

The configuration keeps secrets secret with agenix. In order to deploy the secrets (and to clone this repository over ssh), make sure the necessary keys are installed:

```sh
curl -Lo ssh.zip https://github.com/pjan/archives/raw/refs/heads/main/ssh.zip && unzip ssh.zip -d ~/.ssh && rm ssh.zip
```

### 4. Clone this repository

With all the necessary keys installed, you can now clone this repository. Change directory to where you want to store the repo locally, and clone it:

```sh
git@github.com:pjan/nix-config.git
```

### 5. Make apps executable

Change directory to the repo, and make all

```sh
find apps/$(uname -m | sed 's/arm64/aarch64/')-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name rollback \) -exec chmod +x {} \;
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

## Updating the configuration

## Secrets
