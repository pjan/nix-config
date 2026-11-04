{ pkgs, ... }:

{

  home.packages = with pkgs; [
    tools.ai
    tools.dev
    tools.js
    tools.lang
    # tools.rust
    tools.security

    _1password-cli
    ngrok
    age
    age-plugin-yubikey
    libfido2

    poetry
    python3

    googleworkspace-cli
  ];

}
