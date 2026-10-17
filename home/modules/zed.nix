{
  config,
  lib,
  pkgs,
  ...
}:

{

  programs.zed-editor = lib.mkIf config.editor.zed.enable {
    enable = true;
    mutableUserSettings = true;

    userSettings = {
      vim_mode = true;

      project_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";

      agent = {
        sidebar_side = "right";
        dock = "right";
        default_model = {
          effort = "high";
          provider = "anthropic";
          model = "claude-sonnet-4-6-latest";
          enable_thinking = true;
        };
      };

      languages = {
        HTML = {
          format_on_save = "off";
        };
      };
    };
  };

}
