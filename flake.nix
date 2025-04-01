{

  description = "Configuration for MacOS";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    nixpkgs = {
      url = github:nixos/nixpkgs/nixos-unstable;
    };
    systems = {
      url = github:nix-systems/aarch64-darwin;
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = github:LnL7/nix-darwin/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = github:zhaofengli-wip/nix-homebrew;
    };
    agenix = {
      url = github:ryantm/agenix;
    };
    homebrew-bundle = {
      url = github:homebrew/homebrew-bundle;
      flake = false;
    };
    homebrew-core = {
      url = github:homebrew/homebrew-core;
      flake = false;
    };
    homebrew-cask = {
      url = github:homebrew/homebrew-cask;
      flake = false;
    };
    flake-schemas = {
      url = github:DeterminateSystems/flake-schemas;
    };
    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.systems.follows = "systems";
    };
    secrets = {
      url = git+ssh://git@github.com/pjan/nix-secrets.git;
      flake = false;
    };
  };

  outputs = { self, systems, nixpkgs, home-manager, darwin, nix-homebrew, agenix, homebrew-bundle, homebrew-core, homebrew-cask, flake-schemas, flake-utils, secrets } @inputs:
    let

      vars = import ./config.nix;

      system = "aarch64-darwin";

      overlays =
        # Apply each overlay found in the /overlays directory
        let path = ./nixpkgs/overlays; in with builtins;
        map (n: import (path + ("/" + n)))
            (filter (n: match ".*\\.nix" n != null ||
                        pathExists (path + ("/" + n + "/default.nix")))
                    (attrNames (readDir path)));


      devShell = let pkgs = nixpkgs.legacyPackages.${system}.appendOverlays overlays; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age agenix.packages.${system}.agenix age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };

      mkApp = scriptName: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };

    in {

      devShells.${system} = devShell;

      apps.${system} = {
        "build" = mkApp "build" ;
        "build-switch" = mkApp "build-switch" ;
        "rollback" = mkApp "rollback" ;
      };

      darwinConfigurations.${system} =
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // { inherit overlays vars; };
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            agenix.darwinModules.default
            ./darwin # load the nix-darwin configuration
            ./home   # load the home-manager configuration
            ./brew   # load the nix-homebrew configuration
          ];
        };

    };

}
