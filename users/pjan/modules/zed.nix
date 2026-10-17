{
  config,
  lib,
  ...
}:

{

  programs.zed-editor = lib.mkIf config.editor.zed.enable {

    # null on machines where Zed comes from the brew cask (see editor.zed overlay).
    inherit (config.editor.zed) package;

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

    userSettings = {
      theme = {
        mode = "dark";
        light = "Ayu Light";
        dark = "Nord Dark";
      };
      icon_theme = {
        mode = "dark";
        light = "Zed (Default)";
        dark = "Zed (Default)";
      };
      ui_font_family = "Noto Sans";
      ui_font_size = 14.0;
      buffer_font_family = "Hack Nerd Font Mono";
      buffer_font_size = 12.0;
      buffer_font_features.calt = true;
      terminal = {
        font_size = 12.0;
        font_family = "Hack Nerd Font Mono";
        dock = "bottom";
      };
      git_panel.tree_view = true;
      direnv.enable = true;
    };

  };

}
