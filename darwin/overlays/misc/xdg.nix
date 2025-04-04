{ config, lib, options, pkgs, ... }:

with lib;

let

  cfg = config.xdg;

  defaultCacheHome = "${config.home.homeDirectory}/.cache";
  defaultConfigHome = "${config.home.homeDirectory}/.config";
  defaultDataHome = "${config.home.homeDirectory}/.local/share";
  defaultStateHome = "${config.home.homeDirectory}/.local/state";

in {

  options.xdg = {

    cacheHome = mkOption {
      type = types.path;
      defaultText = "~/.cache";
      description = ''
        Absolute path to directory holding application caches.
      '';
    };

    configHome = mkOption {
      type = types.path;
      defaultText = "~/.config";
      description = ''
        Absolute path to directory holding application configurations.
      '';
    };

    dataHome = mkOption {
      type = types.path;
      defaultText = "~/.local/share";
      description = ''
        Absolute path to directory holding application data.
      '';
    };

    stateHome = mkOption {
      type = types.path;
      defaultText = "~/.local/share";
      description = ''
        Absolute path to directory holding application state.
      '';
    };

  };

  config = {

    xdg.cacheHome = mkDefault defaultCacheHome;
    xdg.configHome = mkDefault defaultConfigHome;
    xdg.dataHome = mkDefault defaultDataHome;
    xdg.stateHome = mkDefault defaultStateHome;

  };

}
