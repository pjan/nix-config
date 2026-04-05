{ config, homebrew-bundle, homebrew-cask, homebrew-core, homebrew-subtlesoft, lib, pkgs, vars,... }:

let

  brewEnabled = vars.brew.enable;
  cleanup = vars.brew.cleanup;
  userName = vars.user.username;

in lib.mkIf brewEnabled {

  nix-homebrew = {
    user = userName;
    enable = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-core" = homebrew-core;
      "nicowald/homebrew-subtlesoft" = homebrew-subtlesoft;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  homebrew = {

    enable = true;

    onActivation =
      {
        autoUpdate = true;
        upgrade = true;
      }
      // lib.optionalAttrs (cleanup != null) {
        inherit cleanup;
      };

    # taps = [ "homebrew/services" "macos-fuse-t/homebrew-cask" ];
    brews = pkgs.callPackage ./brews.nix {};
    casks = pkgs.callPackage ./casks.nix {};

  };

}
