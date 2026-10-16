{
  config,
  pkgs,
  lib,
  ...
}:
# Based on: https://gist.github.com/antifuchs/10138c4d838a63c0a05e725ccd7bccdd

let

  inherit (lib)
    mkOption
    mkIf
    hasSuffix
    concatMapStrings
    types
    ;

  cfg = config.dock.apps;

  inherit (pkgs) dockutil;

in
{

  options = {
    dock.apps.enable = mkOption {
      description = "Enable app management for dock";
      default = false;
    };

    dock.apps.entries = mkOption {
      description = "Entries on the Dock";
      type = types.listOf (
        types.submodule {
          options = {
            path = mkOption { type = types.str; };
            section = mkOption {
              type = types.str;
              default = "apps";
            };
            options = mkOption {
              type = types.str;
              default = "";
            };
          };
        }
      );
      readOnly = true;
    };
  };

  config = mkIf cfg.enable (
    let
      normalize = path: if hasSuffix ".app" path then path + "/" else path;
      entryURI =
        path:
        "file://"
        + (builtins.replaceStrings
          [
            " "
            "!"
            "\""
            "#"
            "$"
            "%"
            "&"
            "'"
            "("
            ")"
          ]
          [
            "%20"
            "%21"
            "%22"
            "%23"
            "%24"
            "%25"
            "%26"
            "%27"
            "%28"
            "%29"
          ]
          (normalize path)
        );
      wantURIs = concatMapStrings (entry: "${entryURI entry.path}\n") cfg.entries;
      createEntries = concatMapStrings (
        entry:
        "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n"
      ) cfg.entries;
    in
    {
      home.activation.dock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo >&2 "Setting up the Dock..."
        haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
        if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
          echo >&2 "Resetting Dock."
          ${dockutil}/bin/dockutil --no-restart --remove all
          ${createEntries}
          killall Dock
        else
          echo >&2 "Dock setup complete."
        fi
      '';
    }
  );
}
