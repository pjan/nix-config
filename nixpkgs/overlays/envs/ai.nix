{ pkgs }:

pkgs.buildEnv {
  name = "ai-tools";
  paths = with pkgs; [
    bmad-method
    claude-code
    codex
    chrome-devtools-mcp
    playwright-mcp
  ];
}
