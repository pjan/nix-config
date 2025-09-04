{ config, lib, pkgs, ... }:

let

in {

  home.sessionVariables."AWS_SHARED_CREDENTIALS_FILE" = "${config.xdg.configHome}/aws/credentials";

}
