{ config, pkgs, agenix, secrets, ... }:

{
  age = {
    identityPaths = [
      "/Users/${config.user.name}/.ssh/id_ed25519_agenix"
    ];

    secrets = {

      "aws_credentials" = {
        symlink = true;
        path = "${config.xdg.configHome}/aws/credentials";
        file =  "${secrets}/aws_credentials.age";
        mode = "644";
        owner = "${config.user.name}";
        group = "staff";
      };

      "etc_nix_public-key" = {
        symlink = true;
        path = "/etc/nix/public-key";
        file =  "${secrets}/etc_nix_public-key.age";
        mode = "644";
        owner = "${config.user.name}";
        group = "staff";
      };

      "etc_nix_secret-key" = {
        symlink = true;
        path = "/etc/nix/secret-key";
        file =  "${secrets}/etc_nix_secret-key.age";
        mode = "644";
        owner = "${config.user.name}";
        group = "staff";
      };

      "rclone-service-account-io-vandaele" = {
        symlink = true;
        path = "${config.xdg.configHome}/rclone/rclone@io-vandaele-home.json";
        file =  "${secrets}/rclone@io-vandaele-home.age";
        mode = "644";
        owner = "${config.user.name}";
        group = "staff";
      };

    };
  };
}
