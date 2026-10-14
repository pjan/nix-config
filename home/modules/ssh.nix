{ config, ... }:

{

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      ForwardAgent = false;
      Compression = true;
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
      HashKnownHosts = true;
      UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };

  };

}
