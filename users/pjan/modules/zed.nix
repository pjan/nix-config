{
  config,
  lib,
  ...
}:

{

  programs.zed-editor = lib.mkIf config.editor.zed.enable {

    enable = true;

    # null on machines where Zed comes from the brew cask (see machines/apollo.nix).
    inherit (config.editor.zed) package;

    # Installed on startup if missing; never uninstalled.
    extensions = [
      "ayu-darker"
      "catppuccin-icons"
      "html"
      "mcp-server-context7"
      "mcp-server-github"
      "nix"
      "nord"
      "toml"
    ];

    # Merged into ~/.config/zed/settings.json on activation (mutableUserSettings
    # defaults to true): settings changed in Zed survive, but the values below
    # win on every switch. Keep volatile, UI-driven settings (agent model etc.)
    # out of here.
    userSettings = {
      theme = {
        mode = "system";
        light = "Nord Light";
        dark = "Ayu Mirage";
      };
      ui_font_size = 16;
      buffer_font_size = 12;
      buffer_font_family = "Hack Nerd Font";
      buffer_font_features.calt = true;
      terminal.dock = "bottom";
      git_panel.tree_view = true;
      direnv.enable = true;
    };

  };

}
