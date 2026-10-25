# tomo's home-manager configuration.
# Imported into home-manager.users."tomo" by mkDarwinSystem.
{
  config,
  lib,
  pkgs,
  ...
}:

{

  user.username = config.home.username;
  user.fullName = "Tomo Vandaele";
  user.email = "";

  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;

  programs.git = {
    enable = true;
    settings.user.name = "Tomo Vandaele";
  };

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ./modules
  );

}
