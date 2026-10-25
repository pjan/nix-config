{
  machine.hostname = null;
  machine.localHostName = "Icarus";
  machine.computerName = "Icarus";
  machine.dns = [ ];

  machine.primaryUser = "pjan";
  machine.users = [
    "pjan"
    "nao"
    "tomo"
  ];

  nix.sslCertFile = null;

  brew = {
    enable = false;
    cleanup = "zap";
    brews = [ ];
    casks = [ ];
  };
}
