{ config, pkgs, ... }:

{

  home.packages = with pkgs; [ wget ];

  home.sessionVariables."WGETRC" = "${config.xdg.configHome}/wget/wgetrc";

  xdg.configFile."wget/wgetrc".source = ../files/wgetrc;

}
