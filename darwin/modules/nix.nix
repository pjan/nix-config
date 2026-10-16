{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  sslCertFile = vars.nix.sslCertFile;
in
{

  nix = {

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@admin"
      ];
      secret-key-files = [
        "/etc/nix/secret-key"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "s3://io-vandaele-nix-cache?endpoint=https://storage.googleapis.com&profile=gcp"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "io-vandaele-nix-cache:O9fdSbSnySVmQFa353NjmU/lP5GifyVfOmDM2XhBs8Q="
      ];
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    }
    // lib.optionalAttrs (sslCertFile != null) {
      ssl-cert-file = sslCertFile;
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Deduplicate identical files in the store (hard links); runs after gc.
    optimise = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
    };

  };

  nix.channel.enable = false;

}
