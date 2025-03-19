{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.user;

in {

  options.user = {

    name = mkOption {
      type = types.str;
      example = "jane.doe";
      description = ''
        The user's username.
      '';
    };

    email = mkOption {
      type = types.str;
      example = "jane.doe@mail.com";
      description = ''
        The user's email.
      '';
    };


  };

  config = {
    assertions = [
      {
        assertion = config.user.name != "";
        message = "User has not been configured";
      }
    ];

  };

}
