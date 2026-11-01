{ pkgs, ... }:

{

  programs.ghostty = {
    enable = true;
    package = null; # installed via environment.systemPackages for Spotlight visibility
    settings = { };
  };

}
