{ config, pkgs, agenix, secrets, ... }:

{
  age = {
    identityPaths = [
      "/Users/${config.user.name}/.ssh/id_ed25519_agenix"
    ];

    secrets = {

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
