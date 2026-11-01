_:

{

  services.aerospace = {
    enable = true;
    settings = {

      # Config version for compatibility and deprecations
      # See: https://nikitabobko.github.io/AeroSpace/guide#config-version
      "config-version" = 2;

      # Commands that run after AeroSpace startup.
      # Available commands: https://nikitabobko.github.io/AeroSpace/commands
      # topmost is configured in sketchybar's own config; no override needed here.
      "after-startup-command" = [];

      # Notify sketchybar immediately when the focused workspace changes.
      # exec-on-workspace-change takes [program, arg, ...], not an AeroSpace command.
      "exec-on-workspace-change" = [ "/bin/bash" "-c" "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE" ];

      exec."env-vars"."PATH" = "/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin";

      # Start AeroSpace at login
      "start-at-login" = false;

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      "enable-normalization-flatten-containers" = true;
      "enable-normalization-opposite-orientation-for-nested-containers" = true;

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # Set 0 to disable accordion padding
      "accordion-padding" = 30;

      # Possible values: tiles|accordion
      "default-root-container-layout" = "tiles";

      # Possible values: horizontal|vertical|auto
      # 'auto': wide monitor → horizontal, tall monitor → vertical
      "default-root-container-orientation" = "auto";

      # Mouse follows focus when focused monitor changes
      # See: https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      "on-focused-monitor-changed" = [ "move-mouse monitor-lazy-center" ];

      # Effectively disables macOS "Hide application" (cmd-h)
      # See: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      "automatically-unhide-macos-hidden-apps" = false;

      # Workspaces that stay alive even when empty/invisible
      "persistent-workspaces" = [
        "1" "2" "3" "4" "5" "6" "7" "8" "9"
        "A" "B" "C" "D" "E" "F" "G" "I" "M"
        "N" "O" "P" "Q" "R" "S" "T" "U" "V"
        "W" "X" "Y" "Z"
      ];

      "focus-follows-mouse" = { enabled = false; };

      # See: https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      "key-mapping" = { preset = "qwerty"; };

      # Gaps between windows (inner-*) and monitor edges (outer-*)
      # See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      gaps = {
        inner.horizontal  = 10;
        inner.vertical = 10;
        outer.left = 15;
        outer.bottom = 15;
        outer.top = 15;
        outer.right = 15;
      };

      mode = {

        # 'main' binding mode — must always be present
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        main.binding = {

          # See: https://nikitabobko.github.io/AeroSpace/commands#layout
          "alt-slash" = "layout tiles horizontal vertical";
          "alt-comma" = "layout accordion horizontal vertical";

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          "alt-h" = "focus left";
          "alt-j" = "focus down";
          "alt-k" = "focus up";
          "alt-l" = "focus right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move
          "alt-shift-h" = "move left";
          "alt-shift-j" = "move down";
          "alt-shift-k" = "move up";
          "alt-shift-l" = "move right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#resize
          "alt-minus" = "resize smart -50";
          "alt-equal" = "resize smart +50";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          "alt-1" = "workspace 1";
          "alt-2" = "workspace 2";
          "alt-3" = "workspace 3";
          "alt-4" = "workspace 4";
          "alt-5" = "workspace 5";
          "alt-6" = "workspace 6";
          "alt-7" = "workspace 7";
          "alt-8" = "workspace 8";
          "alt-9" = "workspace 9";
          "alt-a" = "workspace A";
          "alt-b" = "workspace B";
          "alt-c" = "workspace C";
          "alt-d" = "workspace D";
          "alt-e" = "workspace E";
          "alt-f" = "workspace F";
          "alt-g" = "workspace G";
          "alt-i" = "workspace I";
          "alt-m" = "workspace M";
          "alt-n" = "workspace N";
          "alt-o" = "workspace O";
          "alt-p" = "workspace P";
          "alt-q" = "workspace Q";
          "alt-r" = "workspace R";
          "alt-s" = "workspace S";
          "alt-t" = "workspace T";
          "alt-u" = "workspace U";
          "alt-v" = "workspace V";
          "alt-w" = "workspace W";
          "alt-x" = "workspace X";
          "alt-y" = "workspace Y";
          "alt-z" = "workspace Z";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          "alt-shift-1" = "move-node-to-workspace 1";
          "alt-shift-2" = "move-node-to-workspace 2";
          "alt-shift-3" = "move-node-to-workspace 3";
          "alt-shift-4" = "move-node-to-workspace 4";
          "alt-shift-5" = "move-node-to-workspace 5";
          "alt-shift-6" = "move-node-to-workspace 6";
          "alt-shift-7" = "move-node-to-workspace 7";
          "alt-shift-8" = "move-node-to-workspace 8";
          "alt-shift-9" = "move-node-to-workspace 9";
          "alt-shift-a" = "move-node-to-workspace A";
          "alt-shift-b" = "move-node-to-workspace B";
          "alt-shift-c" = "move-node-to-workspace C";
          "alt-shift-d" = "move-node-to-workspace D";
          "alt-shift-e" = "move-node-to-workspace E";
          "alt-shift-f" = "move-node-to-workspace F";
          "alt-shift-g" = "move-node-to-workspace G";
          "alt-shift-i" = "move-node-to-workspace I";
          "alt-shift-m" = "move-node-to-workspace M";
          "alt-shift-n" = "move-node-to-workspace N";
          "alt-shift-o" = "move-node-to-workspace O";
          "alt-shift-p" = "move-node-to-workspace P";
          "alt-shift-q" = "move-node-to-workspace Q";
          "alt-shift-r" = "move-node-to-workspace R";
          "alt-shift-s" = "move-node-to-workspace S";
          "alt-shift-t" = "move-node-to-workspace T";
          "alt-shift-u" = "move-node-to-workspace U";
          "alt-shift-v" = "move-node-to-workspace V";
          "alt-shift-w" = "move-node-to-workspace W";
          "alt-shift-x" = "move-node-to-workspace X";
          "alt-shift-y" = "move-node-to-workspace Y";
          "alt-shift-z" = "move-node-to-workspace Z";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
          "alt-tab" = "workspace-back-and-forth";
          # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
          "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";

          # See: https://nikitabobko.github.io/AeroSpace/commands#mode
          "alt-shift-semicolon" = "mode service";
        };

        # 'service' binding mode
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        service.binding = {
          esc = [ "reload-config" "mode main" ];
          r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
          f = [ "layout floating tiling" "mode main" ]; # toggle floating/tiling
          backspace = [ "close-all-windows-but-current" "mode main" ];

          "alt-shift-h" = [ "join-with left" "mode main" ];
          "alt-shift-j" = [ "join-with down" "mode main" ];
          "alt-shift-k" = [ "join-with up" "mode main" ];
          "alt-shift-l" = [ "join-with right" "mode main" ];
        };

      };

    };
  };

}
