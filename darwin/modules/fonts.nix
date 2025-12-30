{ config, lib, pkgs, ... }:

let

in {

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      font-awesome
      hack-font
      feather-font
      noto-fonts
      # noto-fonts-emoji
      meslo-lgs-nf
      twemoji-color-font
      nerd-fonts.hack
    ];
  };

}
