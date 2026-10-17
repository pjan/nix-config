{
  machine.hostname = null;
  machine.localHostName = "apollo";
  machine.computerName = "apollo";
  machine.dns = [ ];

  machine.primaryUser = "pjan";
  machine.users = [ "pjan" ];

  nix.sslCertFile = "/etc/nix/ca-bundle.crt";

  brew = {
    enable = true;
    cleanup = "zap";
    brews = [ ];
    casks = [ ];
  };

  # Machine-specific home-manager modules applied to all users on this machine.
  home.extraModules = [
    {
      editor.zed.enable = false;
    }
  ];

}
