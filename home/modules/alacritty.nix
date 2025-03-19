{ config, lib, pkgs, ...}:

let

in {

  programs.alacritty = {

    enable = false;

    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        opacity = 1.0;
        decorations = "Buttonless";
        padding = {
          x = 18;
          y = 18;
        };
      };

      font = {
        normal = {
          family = "Hack NF";
          style = "Regular";
        };
        size = 12;
      };

      # review settings - https://alacritty.org/config-alacritty.html

      colors = {
        primary = {
          background = "0x1e1e2e";
          foreground = "0xcdd6f4";
          dim_foreground = "0x7f849c";
          bright_foreground = "0xcdd6f4";
        };

        cursor = {
          text = "0x1e1e2e";
          cursor = "0xf5e0dc";
        };

        vi_mode_cursor = {
          text = "0x1e1e2e";
          cursor = "0xb4befe";
        };

        search = {
          matches = {
          foreground = "0x1e1e2e";
          background = "0xa6adc8";
          };
          focused_match = {
            foreground = "0x1e1e2e";
            background = "0xa6e3a1";
          };
        };

        footer_bar = {
          foreground = "0x1e1e2e";
          background = "0xa6adc8";
        };

        hints = {
          start = {
            foreground = "0x1e1e2e";
            background = "0xf9e2af";
          };
          end = {
            foreground = "0x1e1e2e";
            background = "0xa6adc8";
          };
        };

        selection = {
          text = "0x1e1e2e";
          background = "0xf5e0dc";
        };

        normal = {
          black = "0x45475a";
          red = "0xf38ba8";
          green = "0xa6e3a1";
          yellow = "0xf9e2af";
          blue = "0x89b4fa";
          magenta = "0xf5c2e7";
          cyan = "0x94e2d5";
          white = "0xbac2de";
        };

        bright = {
          black = "0x585b70";
          red = "0xf38ba8";
          green = "0xa6e3a1";
          yellow = "0xf9e2af";
          blue = "0x89b4fa";
          magenta = "0xf5c2e7";
          cyan = "0x94e2d5";
          white = "0xa6adc8";
        };
      };
    };

  };

  home.activation.kconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /usr/bin/osascript <<EOD
      use framework "AppKit"
      use scripting additions
      set iconURL to current application's NSURL's URLWithString:"https://github.com/bouk/alacritty/blob/604686ba061c714f37d1db7002258517f062f0d2/extra/osx/Alacritty.app/Contents/Resources/alacritty.icns?raw=true"
      set iconImage to (current application's NSImage's alloc)'s initWithContentsOfURL:iconURL
      set workspace to current application's NSWorkspace's sharedWorkspace()
      workspace's setIcon:iconImage forFile:"/Applications/Alacritty.app" options:0
    EOD
  '';

}
