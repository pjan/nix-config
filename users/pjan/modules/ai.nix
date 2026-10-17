{
  config,
  lib,
  pkgs,
  ...
}:

{

  # Shared MCP servers (both Claude Code and Codex).
  # Machine-specific servers (e.g. glean) go in machines/<hostname>.nix home.extraModules.
  ai.mcpServers = {
    github = {
      url = "https://api.githubcopilot.com/mcp/";
      headersHelper = "${config.home.homeDirectory}/.local/bin/github-mcp-headers";
    };
    chrome-devtools = {
      command = "chrome-devtools-mcp";
    };
    context7 = {
      command = "npx";
      args = [ "-y" "@upstash/context7-mcp" ];
    };
    # REA: reverse engineering (native binaries via Hopper, JS/Electron, .NET, web).
    rea = {
      command = "${pkgs.rea-agents}/bin/rea";
      args = [ "mcp" ];
    };
  };

  # Shared skills (both Claude Code and Codex).
  ai.skills = {
    # Bundled with the package, so it always matches the MCP server's version.
    reverse-engineer-anything = pkgs.rea-agents.skill;
  };

  # Claude Code configuration.
  programs.claude-code = {
    enable = true;
    mutableSettings = true;
    settings = {
      env = {
        PATH = "/etc/profiles/per-user/${config.home.username}/bin:${config.home.homeDirectory}/.nix-profile/bin:/usr/local/bin:/usr/bin:/bin";
      };
      permissions = {
        defaultMode = "auto";
      };
      effortLevel = "high";
      autoUpdatesChannel = "latest";
      tui = "fullscreen";
      skipDangerousModePermissionPrompt = true;
      skipAutoPermissionPrompt = true;
      enabledPlugins = {
        "toolkit-skills@claude-code-toolkit" = true;
        "context7@claude-plugins-official" = false;
        "code-review@claude-plugins-official" = true;
        "code-simplifier@claude-plugins-official" = true;
        "github@claude-plugins-official" = false;
        "svelte-skills@svelte-skills-kit" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
      };
      extraKnownMarketplaces = {
        claude-code-toolkit = {
          source = {
            source = "github";
            repo = "spences10/claude-code-toolkit";
          };
        };
        svelte-skills-kit = {
          source = {
            source = "github";
            repo = "spences10/svelte-skills-kit";
          };
        };
      };
    };
  };

  # Codex configuration.
  programs.codex = {
    enable = true;
    mutableSettings = true;
    settings = {
      model = "gpt-6-sol";
      model_reasoning_effort = "high";
      approvals_reviewer = "user";
      service_tier = "default";
      # REA's own setup adds these: Ghidra/Hopper startup can take minutes.
      mcp_servers.rea = {
        startup_timeout_sec = 30;
        tool_timeout_sec = 450;
      };
    };
  };

}
