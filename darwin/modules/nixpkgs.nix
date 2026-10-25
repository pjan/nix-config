{
  config,
  lib,
  overlays,
  pkgs,
  ...
}:

{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = false;

      permittedInsecurePackages = [ ];
    };
    inherit overlays;
  };

}
