{
  config,
  lib,
  overlays,
  pkgs,
  ...
}:

let

in
{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = false;

      permittedInsecurePackages = [ ];
    };
    overlays = overlays;
  };

}
