{ config, lib, pkgs, ... }:

with config;

let

in {

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."lsd/config.yaml".source = ../files/lsd_config.yaml;
  xdg.configFile."lsd/colors.yaml".source = ../files/lsd_colors.yaml;

}
