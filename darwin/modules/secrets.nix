{ config, pkgs, agenix, secrets, ... }:

{
  age = {
    identityPaths = [
      "/Users/${config.user.username}/.ssh/id_ed25519_agenix"
    ];

    secrets = {

      # nix cache aws credentials for user
      "aws_credentials" = {
        symlink = true;
        path = "${config.xdg.configHome}/aws/credentials";
        file =  "${secrets}/aws_credentials.age";
        mode = "644";
        owner = "${config.user.username}";
        group = "staff";
      };

      # nix cache aws credentials for the nix build daemon
      "aws_credentials-root" = {
        symlink = true;
        path = "/var/root/.aws/credentials";
        file =  "${secrets}/aws_credentials.age";
        mode = "600";
      };

      "etc_nix_public-key" = {
        symlink = true;
        path = "/etc/nix/public-key";
        file =  "${secrets}/etc_nix_public-key.age";
        mode = "644";
        owner = "${config.user.username}";
        group = "staff";
      };

      "etc_nix_secret-key" = {
        symlink = true;
        path = "/etc/nix/secret-key";
        file =  "${secrets}/etc_nix_secret-key.age";
        mode = "600";
        owner = "${config.user.username}";
        group = "staff";
      };

      "rclone-service-account-io-vandaele" = {
        symlink = true;
        path = "${config.xdg.configHome}/rclone/rclone@io-vandaele-home.json";
        file =  "${secrets}/rclone@io-vandaele-home.age";
        mode = "600";
        owner = "${config.user.username}";
        group = "staff";
      };

    };
  };
}
