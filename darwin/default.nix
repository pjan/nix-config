{ config, lib, pkgs, vars, ... }:

let

  homeDirectory = config.home.homeDirectory;
  userName = vars.user.username;
  userEmail = vars.user.email;
  computerName = vars.networking.computerName;

in {

  user.username = userName;
  user.email = userEmail;
  networking.computerName = computerName;

  users.users.${userName} = {
    name = userName;
    home = homeDirectory;
    isHidden = false;
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;
  system.checks.verifyNixPath = false;
  system.primaryUser = userName;

  imports = [ ./overlays ] ++ lib.filter
              (n: lib.strings.hasSuffix ".nix" n)
              (lib.filesystem.listFilesRecursive ./modules);

}
