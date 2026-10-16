{
  lib,
  osConfig,
  pkgs,
  ...
}:

{

  # headersHelper for the GitHub MCP server in Claude Code (registered at user scope, see README):
  # prints the Authorization header from the agenix-deployed token, so the token is never
  # exported in the shell environment.
  # Only activated when the github-mcp-token secret is configured on the machine.
  config = lib.mkIf (osConfig.age.secrets ? "github-mcp-token") {
    home.file.".local/bin/github-mcp-headers".source =
      let
        tokenFile = osConfig.age.secrets."github-mcp-token".path;
      in
      pkgs.writeShellScript "github-mcp-headers" ''
        exec ${lib.getExe pkgs.jq} -cn --rawfile t ${tokenFile} '{Authorization: ("Bearer " + ($t | rtrimstr("\n")))}'
      '';
  };

}
