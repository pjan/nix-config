{

  programs.ssh.knownHosts = {
    "github.com" = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
    "atlas" = {
      hostNames = [
        "atlas"
        "atlas.vandaele.io"
        "192.168.2.200"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMPRTxclEkgs3IIhmImJlWtK1gSvCSGzDmhm48bVNS1R";
    };
  };

}
