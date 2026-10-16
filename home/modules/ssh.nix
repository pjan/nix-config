{ config, ... }:

{

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      ForwardAgent = false;
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
      HashKnownHosts = true;
      UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPersist = "no";
      # Keys come from the 1Password SSH agent (Touch ID). ssh still falls back to key files,
      # e.g. the bootstrap deploy key before 1Password runs on a new machine.
      IdentityAgent = ''"${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
    };

    settings."github.com" = {
      IdentitiesOnly = true;
      IdentityFile = "${config.home.homeDirectory}/.ssh/github.pub";
    };

    settings."atlas atlas.vandaele.io" = {
      Hostname = "192.168.2.200";
      User = "pjan";
      IdentitiesOnly = true;
      IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_atlas";
    };

  };

}
