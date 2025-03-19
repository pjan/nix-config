{ config, lib, pkgs, ... }:

let

in {

  programs.direnv = {

    enable = true;
    nix-direnv.enable = true;
    mise.enable = true;

  };

}
