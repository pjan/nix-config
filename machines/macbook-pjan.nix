{
  machine.hostname = null;
  machine.localHostName = "L-FW3C6X79MN";
  machine.computerName = "L-FW3C6X79MN";
  machine.dns = [ ];

  machine.primaryUser = "pieterjan.vandaele";
  machine.users = [ "pieterjan.vandaele" ];

  nix.sslCertFile = "/etc/nix/ca-bundle.crt";

  brew = {
    enable = false;
    cleanup = "zap";
    brews = [ ];
    casks = [ ];
  };

  # Machine-specific home-manager modules applied to all users on this machine.
  home.extraModules = [
    (
      { config, lib, pkgs, ... }:
      {
        home.packages = [ pkgs.salesforce-cli ];
        programs.zsh.shellAliases.zed = lib.mkForce "/Applications/Zed.app/Contents/MacOS/cli -n";

        ai.mcpServers.glean = {
          url = "https://circle-be.glean.com/mcp/default";
        };

        programs.zed-editor.userSettings.agent_servers = {
          claude-acp = {
            type = "custom";
            command = "${config.home.homeDirectory}/.local/share/zed-claude-acp/node_modules/.bin/claude-agent-acp";
            env = {
              NODE_EXTRA_CA_CERTS = "${config.home.homeDirectory}/.certs/root_bundle.pem";
              PATH = "/opt/circle/ai-identity:/usr/bin:/bin:/usr/sbin:/sbin:/etc/profiles/per-user/${config.home.username}/bin:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin";
            };
          };
          codex-acp = {
            type = "registry";
          };
        };
      }
    )
  ];

}
