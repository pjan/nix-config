_:

{

  services.aerospace = {
    enable = true;
    settings = {

      "config-version" = 2;

      "after-startup-command" = [ ];

      # Notify sketchybar when the focused workspace changes.
      "exec-on-workspace-change" = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      exec."env-vars"."PATH" =
        "/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin";

      "start-at-login" = false;

      # Normalizations
      "enable-normalization-flatten-containers" = true;
      "enable-normalization-opposite-orientation-for-nested-containers" = true;

      "accordion-padding" = 30;
      "default-root-container-layout" = "tiles";
      "default-root-container-orientation" = "auto";

      # Mouse follows focused window (not just monitor)
      "on-focused-monitor-changed" = [ "move-mouse monitor-lazy-center" ];
      "on-focus-changed" = [ "move-mouse window-lazy-center" ];

      # Prevent cmd-h from hiding windows (breaks tiling tree)
      "automatically-unhide-macos-hidden-apps" = true;

      # Workspaces
      #   External monitor: B (Browser), S (Slack)
      #   Laptop: T (Terminal), E (Editor), A (AI), M (Music), C (Chat), D (Design)
      "persistent-workspaces" = [
        "B"
        "S"
        "T"
        "E"
        "A"
        "M"
        "C"
        "D"
      ];

      # Pin workspaces to monitors
      # main = external (macOS primary), secondary = laptop
      # When external is disconnected, all workspaces fall back to the laptop.
      "workspace-to-monitor-force-assignment" = {
        "B" = "main";
        "S" = "main";
        "T" = "secondary";
        "E" = "secondary";
        "A" = "secondary";
        "M" = "secondary";
        "C" = "secondary";
        "D" = "secondary";
      };

      "key-mapping" = {
        preset = "qwerty";
      };

      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 15;
          bottom = 15;
          top = 15;
          right = 15;
        };
      };

      # Auto-assign apps to workspaces
      "on-window-detected" = [

        # B — Browser
        {
          "if"."app-id" = "com.google.Chrome";
          run = [ "move-node-to-workspace B" ];
        }

        # S — Slack
        {
          "if"."app-id" = "com.tinyspeck.slackmacgap";
          run = [ "move-node-to-workspace S" ];
        }

        # T — Terminal
        {
          "if"."app-id" = "com.mitchellh.ghostty";
          run = [ "move-node-to-workspace T" ];
        }
        {
          "if"."app-id" = "com.googlecode.iterm2";
          run = [ "move-node-to-workspace T" ];
        }

        # E — Editor
        {
          "if"."app-id" = "dev.zed.Zed";
          run = [ "move-node-to-workspace E" ];
        }
        {
          "if"."app-id" = "com.microsoft.VSCode";
          run = [ "move-node-to-workspace E" ];
        }

        # A — AI
        {
          "if"."app-id" = "com.anthropic.claudefordesktop";
          run = [ "move-node-to-workspace A" ];
        }
        {
          "if"."app-id" = "com.openai.codex";
          run = [ "move-node-to-workspace A" ];
        }

        # M — Music
        {
          "if"."app-id" = "com.roon.Roon";
          run = [ "move-node-to-workspace M" ];
        }
        {
          "if"."app-id" = "com.tidal.desktop";
          run = [ "move-node-to-workspace M" ];
        }
        {
          "if"."app-id" = "com.apple.Music";
          run = [ "move-node-to-workspace M" ];
        }

        # C — Chat (personal comms)
        {
          "if"."app-id" = "com.DiscordInc.Discord";
          run = [ "move-node-to-workspace C" ];
        }
        {
          "if"."app-id" = "ru.keepcoder.Telegram";
          run = [ "move-node-to-workspace C" ];
        }
        {
          "if"."app-id" = "net.whatsapp.WhatsApp";
          run = [ "move-node-to-workspace C" ];
        }
        {
          "if"."app-id" = "com.codeux.irc.textual5";
          run = [ "move-node-to-workspace C" ];
        }

        # D — Design (personal machines)
        {
          "if"."app-id" = "com.adobe.Photoshop";
          run = [ "move-node-to-workspace D" ];
        }
        {
          "if"."app-id" = "com.adobe.Lightroom";
          run = [ "move-node-to-workspace D" ];
        }
        {
          "if"."app-id" = "com.adobe.LightroomClassicCC7";
          run = [ "move-node-to-workspace D" ];
        }
        {
          "if"."app-id" = "com.adobe.illustrator";
          run = [ "move-node-to-workspace D" ];
        }

        # Float — apps that don't tile well
        {
          "if"."app-id" = "com.apple.systempreferences";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.1password.1password";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.finder";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.calculator";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.Terminal";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.Preview";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.ActivityMonitor";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.keychainaccess";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.archiveutility";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.apple.installer";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.knollsoft.Hyperkey";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "eu.exelban.Stats";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.jordanbaird.Ice";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.pais.handy";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.tinycast.app";
          run = [ "layout floating" ];
        }
        {
          "if"."app-id" = "com.colliderli.iina";
          run = [ "layout floating" ];
        }
      ];

      mode = {

        main.binding = {

          # Layout
          "alt-slash" = "layout tiles horizontal vertical";
          "alt-comma" = "layout accordion horizontal vertical";
          "alt-shift-f" = "fullscreen";

          # Focus (vim-style)
          "alt-h" = "focus left";
          "alt-j" = "focus down";
          "alt-k" = "focus up";
          "alt-l" = "focus right";

          # Move window
          "alt-shift-h" = "move left";
          "alt-shift-j" = "move down";
          "alt-shift-k" = "move up";
          "alt-shift-l" = "move right";

          # Resize
          "alt-minus" = "resize smart -50";
          "alt-equal" = "resize smart +50";

          # Focus monitor
          "alt-left" = "focus-monitor left";
          "alt-right" = "focus-monitor right";

          # Move workspace to monitor
          "alt-shift-left" = "move-workspace-to-monitor --wrap-around prev";
          "alt-shift-right" = "move-workspace-to-monitor --wrap-around next";

          # Workspaces
          "alt-b" = "workspace B";
          "alt-s" = "workspace S";
          "alt-t" = "workspace T";
          "alt-e" = "workspace E";
          "alt-a" = "workspace A";
          "alt-m" = "workspace M";
          "alt-c" = "workspace C";
          "alt-d" = "workspace D";

          # Move window to workspace
          "alt-shift-b" = "move-node-to-workspace B";
          "alt-shift-s" = "move-node-to-workspace S";
          "alt-shift-t" = "move-node-to-workspace T";
          "alt-shift-e" = "move-node-to-workspace E";
          "alt-shift-a" = "move-node-to-workspace A";
          "alt-shift-m" = "move-node-to-workspace M";
          "alt-shift-c" = "move-node-to-workspace C";
          "alt-shift-d" = "move-node-to-workspace D";

          # Quick switch
          "alt-tab" = "workspace-back-and-forth";

          # Service mode
          "alt-shift-semicolon" = "mode service";
        };

        service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];

          "alt-shift-h" = [
            "join-with left"
            "mode main"
          ];
          "alt-shift-j" = [
            "join-with down"
            "mode main"
          ];
          "alt-shift-k" = [
            "join-with up"
            "mode main"
          ];
          "alt-shift-l" = [
            "join-with right"
            "mode main"
          ];
        };

      };

    };
  };

}
