{ config, lib, overlays, pkgs, ... }:

let

in {

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowInsecure = false;
      allowUnsupportedSystem = false;

      permittedInsecurePackages = [ ];
    };
    overlays = overlays;
  };

}
