{ config, homebrew-bundle, homebrew-cask, homebrew-core, homebrew-subtlesoft, lib, pkgs, vars,... }:

let

in {

  nix-homebrew = {
    user = vars.user.name;
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

    onActivation = {
      # "zap" removes manually installed brews and casks
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    # taps = [ "homebrew/services" "macos-fuse-t/homebrew-cask" ];
    brews = pkgs.callPackage ./brews.nix {};
    casks = pkgs.callPackage ./casks.nix {};

  };

}
