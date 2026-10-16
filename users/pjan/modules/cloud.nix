{ config, vars, ... }:

{

  home.sessionVariables."AWS_SHARED_CREDENTIALS_FILE" = "${config.xdg.configHome}/aws/credentials";
  home.sessionPath = vars.shell.sessionPath or [ ];

}
