{
  config,
  homebrew-bundle,
  homebrew-cask,
  homebrew-core,
  homebrew-subtlesoft,
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

in
lib.mkIf brewEnabled {

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

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    }
    // lib.optionalAttrs (cleanup != null) {
      inherit cleanup;
    };

    brews = sharedBrews ++ machineBrews;
    casks = sharedCasks ++ machineCasks;

  };

}
