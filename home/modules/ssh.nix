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
      # Keys come from the 1Password SSH agent (Touch ID). ssh still falls back to key files,
      # e.g. the bootstrap deploy key before 1Password runs on a new machine.
      IdentityAgent = ''"${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
    };

  };

}
