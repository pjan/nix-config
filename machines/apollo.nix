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
    casks = [
      # Brew cask rather than nixpkgs zed-editor: Zed self-updates in-app.
      # NB: with cleanup = "zap", dropping this also trashes ~/.config/zed.
      "zed"
    ];
  };

  # Machine-specific home-manager modules applied to all users on this machine.
  home.extraModules = [
    {
      # Zed comes from the brew cask above.
      editor.zed.package = null;
    }
  ];

}
