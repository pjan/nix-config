{ pkgs }:

with pkgs; [

  tools.git
  tools.lang
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

  # Cloud-related tools and SDKs
  flyctl
  docker
  docker-compose

  # Media-related packages
  ffmpeg

  # nix
  lorri

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text and terminal utilities
  hunspell
  jetbrains-mono
  jq
  yazi

  # Python packages
  python3
  virtualenv
]
