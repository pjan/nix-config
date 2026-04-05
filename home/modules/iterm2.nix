{ config, lib, pkgs, ... }:

let

  iterm2Template = builtins.readFile ../files/com.googlecode.iterm2.plist;

in {

  xdg.configFile."iterm2/com.googlecode.iterm2.plist".text =
    builtins.replaceStrings
      [ "@HOME_DIRECTORY@" ]
      [ config.home.homeDirectory ]
      iterm2Template;

}
