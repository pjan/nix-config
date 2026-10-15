{
  lib,
  osConfig,
  pkgs,
  ...
}:

let

  tokenFile = osConfig.age.secrets."github-mcp-token".path;

in
{

  # headersHelper for the GitHub MCP server in Claude Code (registered at user scope, see README):
  # prints the Authorization header from the agenix-deployed token, so the token is never
  # exported in the shell environment.
  home.file.".local/bin/github-mcp-headers".source = pkgs.writeShellScript "github-mcp-headers" ''
    exec ${lib.getExe pkgs.jq} -cn --rawfile t ${tokenFile} '{Authorization: ("Bearer " + ($t | rtrimstr("\n")))}'
  '';

}
