{ config, lib, pkgs, ... }:

with config;

let

in {

  programs.zoxide = {
    enable = true;
  };

}
