{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.system.defaults.dock.apps;

  inherit (pkgs) stdenv dockutil killall;

in {

  options = {
    system.defaults.dock.apps.enable = mkOption {
      description = "Enable app management for dock";
      default = false;
      example = false;
    };

    system.defaults.dock.apps.entries = mkOption
      {
        description = "Entries on the Dock";
        type = with types; listOf (submodule {
          options = {
            path = lib.mkOption { type = str; };
            section = lib.mkOption {
              type = str;
              default = "apps";
            };
            options = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
        readOnly = true;
      };
  };

  config =
    mkIf cfg.enable
      (
        let
          normalize = path: if hasSuffix ".app" path then path + "/" else path;
          entryURI = path: "file://" + (builtins.replaceStrings
            [" "   "!"   "\""  "#"   "$"   "%"   "&"   "'"   "("   ")"]
            ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
            (normalize path)
          );
          wantURIs = concatMapStrings
            (entry: "${entryURI entry.path}\n")
            cfg.entries;
          createEntries = concatMapStrings
            (entry: "${dockutil}/bin/dockutil --allhomes --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options} ${config.home.homeDirectory}\n")
            cfg.entries;
        in
        {
          system.activationScripts.postActivation.text = ''
            echo >&2 "Setting up the Dock..."
            haveURIs="$(${dockutil}/bin/dockutil --list --allhomes | ${pkgs.coreutils}/bin/cut -f2)"
            if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
              echo >&2 "Resetting Dock."
              ${dockutil}/bin/dockutil --allhomes --no-restart --remove all
              ${createEntries}
              ${killall}/bin/killall Dock
            else
              echo >&2 "Dock setup complete."
            fi
          '';
        }
      );
}
