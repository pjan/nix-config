# pjan's home-manager configuration.
# Imported into home-manager.users.<username> by mkDarwinSystem.
# username varies per machine (pieterjan.vandaele on work, pjan on personal).
{
  config,
  lib,
  pkgs,
  ...
}:

{

  user = {
    username = config.home.username;
    fullName = "Pieterjan Vandaele";
    email = "pjan@vandaele.io";
  };

  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;
  dock.apps = {
    enable = true;
    entries = [
      { path = "/Applications/iTerm.app/"; }
      { path = "/Applications/TIDAL.app/"; }
      { path = "/Applications/Google Chrome.app/"; }
      {
        path = "${config.home.homeDirectory}/Downloads";
        section = "others";
        options = "--sort dateadded --view grid --display stack";
      }
    ];
  };

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ./modules
  );

}
