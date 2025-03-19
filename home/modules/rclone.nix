{ config, lib, pkgs, ... }:

let

in {

  programs.rclone = {

    enable = true;

    remotes = {

      media.config = {
        type = "drive";
        scope = "drive";
        auth_owner_only = false;
        team_drive = "0AAbR4e-Vwc1vUk9PVA";
        impersonate = config.user.email;
        service_account_file = "${config.xdg.configHome}/rclone/rclone@io-vandaele-home.json";
      };

      resources.config = {
        type = "drive";
        scope = "drive";
        auth_owner_only = false;
        team_drive = "0AF79SYx4cBpyUk9PVA";
        impersonate = config.user.email;
        service_account_file = "${config.xdg.configHome}/rclone/rclone@io-vandaele-home.json";
      };

      vaults.config = {
        type = "drive";
        scope = "drive";
        auth_owner_only = false;
        team_drive = "0APvpIONzs0C0Uk9PVA";
        impersonate = config.user.email;
        service_account_file = "${config.xdg.configHome}/rclone/rclone@io-vandaele-home.json";
      };

    };

  };

}
