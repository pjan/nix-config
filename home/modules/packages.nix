{
  config,
  lib,
  pkgs,
  ...
}:

{

  home.packages = with pkgs; [
    tools.git
    tools.media
    tools.network
    tools.nix
    tools.system

    btop
    fastfetch
    hunspell
    openssh
    yazi
  ];

}
