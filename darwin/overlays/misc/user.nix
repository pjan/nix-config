{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.user;

in {

  options.user = {

    username = mkOption {
      type = types.str;
      example = "jane.doe";
      description = ''
        The user's username.
      '';
    };

    fullName = mkOption {
      type = types.str;
      default = "";
      example = "Jane Doe";
      description = ''
        The user's full display name.
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
        assertion = config.user.username != "";
        message = "User has not been configured";
      }
    ];

  };

}
