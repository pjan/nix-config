{ pkgs }:

with pkgs; [

  tools.dev
  tools.git
  tools.js
  tools.lang
  tools.media
  tools.network
  tools.nix
# tools.rust
  tools.security
  tools.system

  # General packages for development and system management
  btop
  neofetch
  openssh

  # Encryption and security tools
  age
  age-plugin-yubikey
  libfido2

  # Text and terminal utilities
  hunspell
  jetbrains-mono
  jq
  yazi

  # Python packages
  poetry
  python3
  uv
  virtualenv
]
