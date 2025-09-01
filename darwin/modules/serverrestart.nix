{ config, lib, pkgs, ... }:

let

  hostname = config.networking.computerName;

in {

  launchd.user.agents.scheduledRestart = lib.mkIf (hostname == "zeus") {
    script = ''
      sudo shutdown -r now
    '';
    serviceConfig = {
      StartCalendarInterval = [
        { Weekday = 1; Hour = 2; Minute = 0; }
        { Weekday = 4; Hour = 2; Minute = 0; }
      ];
      RunAtLoad = false;
      KeepAlive = false;
    };
  };

}
