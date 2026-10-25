{
  machine = {
    hostname = null;
    localHostName = "Icarus";
    computerName = "Icarus";
    dns = [ ];
    primaryUser = "pjan";
    users = [
      "pjan"
      "nao"
      "tomo"
    ];
  };

  nix.sslCertFile = null;

  brew = {
    enable = false;
    cleanup = "zap";
    brews = [ ];
    casks = [ ];
  };
}
