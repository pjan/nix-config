{
  config,
  homebrew-cask,
  homebrew-core,
  homebrew-subtlesoft,
  homebrew-tinycast,
  lib,
  pkgs,
  vars,
  ...
}:

let

  brewEnabled = vars.brew.enable;
  cleanup = vars.brew.cleanup;
  userName = vars.machine.primaryUser;

  # Shared brews/casks (common across all machines).
  sharedBrews = import ./brews.nix { };
  sharedCasks = import ./casks.nix { };

  # Machine-specific brews/casks (defined in machines/<hostname>.nix).
  machineBrews = vars.brew.brews or [ ];
  machineCasks = vars.brew.casks or [ ];
  caskAppdir = vars.brew.caskAppdir or null;

in
lib.mkIf brewEnabled {

  nix-homebrew = {
    user = userName;
    enable = true;
    taps = {
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-core" = homebrew-core;
      "nicowald/homebrew-subtlesoft" = homebrew-subtlesoft;
      "abue-ammar/homebrew-tinycast" = homebrew-tinycast;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  homebrew = {

    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    }
    // lib.optionalAttrs (cleanup != null) {
      inherit cleanup;
    };

    # Declare the nix-homebrew managed taps so `brew bundle --cleanup`
    # doesn't try to untap them (they're read-only store paths).
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = sharedBrews ++ machineBrews;
    casks = sharedCasks ++ machineCasks;
    caskArgs = lib.optionalAttrs (caskAppdir != null) {
      appdir = caskAppdir;
    };

  };

}
