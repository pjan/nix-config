{ config, lib, pkgs, ... }:

with config;

let

in {

  xdg.configFile."iterm2/com.googlecode.iterm2.plist".source = ../files/com.googlecode.iterm2.plist;

}
