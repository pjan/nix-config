{ config, lib, ... }:

let
  inherit (lib) mkOption mkDefault types;

  defaultHome = "/Users/${config.user.username}";
in {

  options.home = {

    homeDirectory = mkOption {
      type = types.path;
      example = "/home/jane.doe";
      description = "The user's home directory. Must be an absolute path.";
    };

  };

  config = {
    assertions = [
      {
        assertion = config.home.homeDirectory != "";
        message = "Home directory could not be determined";
      }
    ];

    home.homeDirectory = mkDefault defaultHome;
  };

}
