{ config, lib, pkgs, vars, ... }:

let
  sslCertFile = vars.nix.sslCertFile;
in {

  nix = {

    package = pkgs.nix;

    settings = {
      trusted-users = [ "@admin" "${config.user.username}" ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "s3://io-vandaele-nix-cache?endpoint=https://storage.googleapis.com&profile=gcp"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "io-vandaele-nix-cache:O9fdSbSnySVmQFa353NjmU/lP5GifyVfOmDM2XhBs8Q="
      ];
    } // lib.optionalAttrs (sslCertFile != null) {
      ssl-cert-file = sslCertFile;
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

}
