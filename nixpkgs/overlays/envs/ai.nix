{ pkgs }:

pkgs.buildEnv {
  name = "ai-tools";
  paths = with pkgs; [
    bmad-method
    claude-code
    codex
    herdr # agent multiplexer for the terminal
    chrome-devtools-mcp
    playwright-mcp
    rea-agents
  ];
}
