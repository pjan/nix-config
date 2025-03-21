{ config, lib, pkgs, ... }:

with config;

let

in {

  programs.ssh = {
    enable = true;

    forwardAgent = true;
    compression = true;
    serverAliveInterval = 60;

    hashKnownHosts = true;
    #userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";

  };



}
