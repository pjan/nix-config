{ config, lib, pkgs, ... }:

let

in {

  programs.fzf = {

    enable = true;

    tmux.enableShellIntegration = true;

  };

}
