{ lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{

  options.editor.zed = {

    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to set up the Zed editor: the `zed` and `code` shell aliases
        and the user's Zed settings (see users/<name>/modules/zed.nix).
      '';
    };

    package = lib.mkPackageOption pkgs "zed-editor" {
      nullable = true;
      extraDescription = ''
        Set to null when Zed is installed outside of Nix (e.g. the `zed` brew
        cask, which self-updates); the `zed` alias then points at the CLI
        bundled in /Applications/Zed.app instead of this package's `zeditor`.
      '';
    };

  };

}
