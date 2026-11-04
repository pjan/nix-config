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
    enable = true;
    cleanup = "zap";
    brews = [ ];
    casks = (import ./modules/casks.nix).private;
  };
}
