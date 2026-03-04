{ config, lib, pkgs, ... }:

let

in {

  programs.riptide = {

    enable = true;

    service.enable = true;

    settings = {
      download.download_path = "${config.home.homeDirectory}/Downloads/riptide";
      download.scan_path = "${config.home.homeDirectory}/Downloads/riptide";
    };

  };

}
