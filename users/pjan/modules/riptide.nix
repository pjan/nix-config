{
  config,
  lib,
  pkgs,
  ...
}:

{

  programs.riptide = {

    enable = true;

    settings = {
      download.download_root = "${config.home.homeDirectory}/Downloads/riptide";
    };

  };

}
