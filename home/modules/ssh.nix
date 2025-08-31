{ config, lib, pkgs, ... }:

with config;

let

in {

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = {
      forwardAgent = true;
      compression = true;
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      hashKnownHosts = true;
      userKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };

  };



}
