{
  machine = {
    hostname = null;
    localHostName = "apollo";
    computerName = "apollo";
    dns = [ ];
    primaryUser = "pjan";
    users = [ "pjan" ];
  };

  nix.sslCertFile = "/etc/nix/ca-bundle.crt";

  brew = {
    enable = true;
    cleanup = "zap";
    brews = [ ];
    casks = (import ./modules/casks.nix).private;
  };

  # Machine-specific home-manager modules applied to all users on this machine.
  home.extraModules = [
    {
      # Zed comes from the brew cask above.
      editor.zed.package = null;
    }
  ];

}
