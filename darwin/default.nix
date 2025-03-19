{ config, lib, pkgs, vars, ... }:

let

  homeDirectory = config.home.homeDirectory;
  userName = vars.user.name;
  userEmail = vars.user.email;

in {

  user.name = userName;
  user.email = userEmail;
  networking.computerName = vars.hostname;

  users.users.${userName} = {
    name = userName;
    home = homeDirectory;
    isHidden = false;
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;
  system.checks.verifyNixPath = false;

  imports = [ ./overlays ] ++ lib.filter
              (n: lib.strings.hasSuffix ".nix" n)
              (lib.filesystem.listFilesRecursive ./modules);

}
