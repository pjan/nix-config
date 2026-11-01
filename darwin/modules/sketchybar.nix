{ pkgs, ... }:

{

  services.sketchybar = {
    enable = true;
    # The Lua config is managed by home-manager (users/pjan/modules/sketchybar.nix),
    # which symlinks users/pjan/sketchybar/ → ~/.config/sketchybar/.
    #
    # This wrapper uses absolute nix store paths so the launchd environment
    # does not need lua or sbarlua on PATH. It delegates entirely to init.lua.
    config = ''
      #!/bin/bash
      CONFIG_DIR="$HOME/.config/sketchybar"
      # Add home-manager profile to PATH so sbar.exec scripts can reach
      # sketchybar-cpu-usage, icon_map.sh, and other home-manager-installed tools.
      export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
      exec ${pkgs.lua5_5}/bin/lua \
        -e "package.cpath='${pkgs.sbarlua}/lib/lua/5.5/?.so;'..package.cpath;package.path='$CONFIG_DIR/?.lua;'..package.path" \
        "$CONFIG_DIR/init.lua"
    '';
  };

}
