{ config, inputs, lib, pkgs, vars, ... }:

let

  cacheHome = config.xdg.cacheHome;
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
  stateHome = config.xdg.stateHome;
  userName = vars.user.username;
  userFullName = vars.user.fullName;
  userEmail = vars.user.email;

in {

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs vars; };
  home-manager.users.${userName} = { ... }:{

    user.username = userName;
    user.fullName = userFullName;
    user.email = userEmail;

    xdg.cacheHome = cacheHome;
    xdg.configHome = configHome;
    xdg.dataHome = dataHome;
    xdg.stateHome = stateHome;

    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = false;
    home.packages = pkgs.callPackage ./packages {};

    imports = [ ./overlays ]
      ++ lib.filter (n: lib.strings.hasSuffix ".nix" n)
           (lib.filesystem.listFilesRecursive ./modules)
      ++ lib.optional (builtins.pathExists ./overrides.nix) ./overrides.nix;

  };

}
