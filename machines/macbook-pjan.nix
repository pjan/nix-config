{
  machine.hostname = null;
  machine.localHostName = "L-FW3C6X79MN";
  machine.computerName = "L-FW3C6X79MN";
  machine.dns = [ ];

  machine.primaryUser = "pieterjan.vandaele";
  machine.users = [ "pieterjan.vandaele" ];

  nix.sslCertFile = "/etc/nix/ca-bundle.crt";

  brew = {
    enable = false;
    cleanup = "zap";
    brews = [ ];
    casks = [ ];
  };

  # Machine-specific darwin modules applied to all users on this machine.
  darwin.extraModules = [
    (
      { ... }:
      {
      }
    )
  ];

  # Machine-specific home-manager modules applied to all users on this machine.
  home.extraModules = [
    (
      { lib, pkgs, ... }:
      {
        home.packages = [ pkgs.salesforce-cli ];
        programs.zsh.shellAliases.zed = lib.mkForce "/Applications/Zed.app/Contents/MacOS/cli -n";
      }
    )
  ];

}
