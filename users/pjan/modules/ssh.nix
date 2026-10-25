{ config, ... }:

let

  # Public half of the "Github (pjan)" SSH key in 1Password.
  # Same key used for git signing in git.nix.
  githubPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0L6BtkYnTzCxl5L2UlPsp18Im68t0mLE56NhZQZMWK";

in
{

  # Provision the GitHub public key so SSH can offer it with IdentitiesOnly.
  home.file.".ssh/github.pub" = {
    text = "${githubPubKey}\n";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
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

      "github.com" = {
        IdentitiesOnly = true;
        IdentityFile = "${config.home.homeDirectory}/.ssh/github.pub";
      };

      # atlas NAS key is provisioned by agenix (darwin/modules/secrets.nix → atlas-ssh-key).
      "atlas atlas.vandaele.io" = {
        Hostname = "192.168.2.200";
        User = "pjan";
        IdentitiesOnly = true;
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_atlas";
      };
    };

  };

}
