{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{

  options.editor.zed = {

    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to set up the Zed editor: the `zed` and `code` shell aliases,
        which pull zed-editor from nixpkgs into the closure.
      '';
    };

  };

}
