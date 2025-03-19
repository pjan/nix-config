{ config, inputs, lib, pkgs, ... }:

let

  cacheHome = config.xdg.cacheHome;
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
  stateHome = config.xdg.stateHome;
  userName = config.user.name;
  userEmail = config.user.email;

in {

  home-manager.useGlobalPkgs = true;
  home-manager.users.${userName} = { ... }:{

    user.name = userName;
    user.email = userEmail;

    xdg.cacheHome = cacheHome;
    xdg.configHome = configHome;
    xdg.dataHome = dataHome;
    xdg.stateHome = stateHome;

    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = false;
    home.packages = pkgs.callPackage ./packages {};

    imports = [./overlays] ++ lib.filter
                (n: lib.strings.hasSuffix ".nix" n)
                (lib.filesystem.listFilesRecursive ./modules);

  };

}
