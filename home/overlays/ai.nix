# Unified AI tools overlay: define MCP servers and skills once,
# automatically configured for both Claude Code and Codex.
#
# Tool-specific settings (plugins, model, permissions) go directly
# in programs.claude-code.settings / programs.codex.settings.
{ config, lib, ... }:

let
  cfg = config.ai;

  # Fields that need renaming from the shared schema to Codex's snake_case.
  codexRenames = {
    bearerTokenEnvVar = "bearer_token_env_var";
    headersHelper = "http_headers_helper";
  };

  sharedKeys = builtins.attrNames codexRenames;

  # Map a shared MCP server definition to Codex format (snake_case keys).
  toCodexMcp =
    _name: server:
    let
      base = builtins.removeAttrs server sharedKeys;
      renamed = lib.filterAttrs (_: v: v != null) (
        lib.mapAttrs' (
          from: to:
          lib.nameValuePair to (server.${from} or null)
        ) codexRenames
      );
    in
    base // renamed;
in
{

  options.ai = {

    mcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = { };
      description = ''
        MCP servers shared between Claude Code and Codex.

        Stdio servers use command/args/env (identical for both tools).
        HTTP servers use url; set bearerTokenEnvVar for token auth
        or headersHelper for script-based auth (automatically mapped to
        bearer_token_env_var / http_headers_helper for Codex).

        Tool-specific servers should be added directly via
        programs.claude-code.mcpServers or programs.codex.settings.mcp_servers.
      '';
      example = {
        github = {
          url = "https://api.githubcopilot.com/mcp/";
          headersHelper = "~/.local/bin/github-mcp-headers";
        };
        chrome-devtools = {
          command = "chrome-devtools-mcp";
        };
      };
    };

    skills = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.lines lib.types.path);
      default = { };
      description = ''
        Skills shared between Claude Code and Codex.
        Each entry is a skill name mapped to either inline SKILL.md content
        or a path (or store-path string, e.g. a package's skill directory)
        to a skill directory/file.
      '';
      example = {
        rust = "/path/to/rust-skill";
        pdf = ''
          # PDF Processing
          Use pdfplumber to extract text from PDFs.
        '';
      };
    };

  };

  config = lib.mkIf (cfg.mcpServers != { } || cfg.skills != { }) {

    # Claude Code: pass MCP servers as-is (Claude accepts bearerTokenEnvVar natively).
    programs.claude-code.mcpServers = cfg.mcpServers;

    # Codex: map bearerTokenEnvVar → bearer_token_env_var.
    programs.codex.settings.mcp_servers = lib.mapAttrs toCodexMcp cfg.mcpServers;

    # Skills via the native HM options (~/.claude/skills/<name>/, ~/.codex/skills/<name>/).
    programs.claude-code.skills = cfg.skills;
    programs.codex.skills = cfg.skills;

  };

}
