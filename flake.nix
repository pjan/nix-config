{

  description = "Configuration for MacOS";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    nix-claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nix-pkgs = {
      url = "github:pjan/nix-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-utils.inputs.systems.follows = "systems";
    };
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-utils.inputs.systems.follows = "systems";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-subtlesoft = {
      url = "github:nicowald/homebrew-subtlesoft";
      flake = false;
    };
    secrets = {
      url = "git+ssh://git@github.com/pjan/nix-secrets.git";
      flake = false;
    };
    # flake imports
    beatport-dl = {
      url = "github:pjan/beatport-dl";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-utils.inputs.systems.follows = "systems";
    };
    riptide = {
      url = "github:pjan/riptide";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      systems,
      home-manager,
      darwin,
      nix-homebrew,
      agenix,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      homebrew-subtlesoft,
      secrets,
      beatport-dl,
      riptide,
      nix-claude-code,
      codex-cli-nix,
      nix-pkgs,
    }@inputs:
    let

      system = "aarch64-darwin";

      overlays =
        # Apply each overlay found in the /overlays directory
        let
          path = ./nixpkgs/overlays;
          importOverlays =
            with builtins;
            map (n: import (path + ("/" + n))) (
              filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))) (
                attrNames (readDir path)
              )
            );
          flakeOverlays = [
            beatport-dl.overlays."${system}".default
            nix-claude-code.overlays.default
            codex-cli-nix.overlays.default
            nix-pkgs.overlays.default
          ];
        in
        importOverlays ++ flakeOverlays;

      mkDarwinSystem = import ./lib/mkDarwinSystem.nix { inherit inputs overlays; };

      devShell =
        let
          pkgs = nixpkgs.legacyPackages.${system}.appendOverlays overlays;
        in
        {
          default =
            with pkgs;
            mkShell {
              nativeBuildInputs = with pkgs; [
                bashInteractive
                git
                age
                agenix.packages.${system}.agenix
                age-plugin-yubikey
              ];
              shellHook = with pkgs; ''
                export EDITOR=vim
              '';
            };
        };

      mkApp = scriptName: {
        type = "app";
        program = "${
          (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
            #!/usr/bin/env bash
            PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
            echo "Running ${scriptName} for ${system}"
            exec ${self}/apps/${system}/${scriptName} "$@"
          '')
        }/bin/${scriptName}";
        meta.description = "nix-darwin ${scriptName} for ${system}";
      };

      # Runs on a new machine before its first build, so it may only depend on nixpkgs:
      # inputs are fetched lazily, and the private `secrets` input is not reachable yet.
      bootstrapPkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "1password-cli";
      };
      bootstrapApp = {
        type = "app";
        program = nixpkgs.lib.getExe (
          bootstrapPkgs.writeShellApplication {
            name = "bootstrap";
            runtimeInputs = with bootstrapPkgs; [
              _1password-cli
              git
              jq
              openssh
            ];
            text = builtins.readFile ./apps/${system}/bootstrap;
          }
        );
        meta.description = "Restore the SSH keys a new machine needs for its first build from 1Password";
      };

    in
    {

      devShells.${system} = devShell;

      # `nix fmt`: nixfmt (official Nix style) over all tracked .nix files.
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      apps.${system} = {
        "bootstrap" = bootstrapApp;
        "build" = mkApp "build";
        "build-cache" = mkApp "build-cache";
        "build-switch" = mkApp "build-switch";
        "cache" = mkApp "cache";
        "rollback" = mkApp "rollback";
        "switch" = mkApp "switch";
      };

      # Auto-discover machine configs from machines/*.nix, keyed by localHostName.
      darwinConfigurations =
        let
          machineFiles = builtins.filter (n: nixpkgs.lib.hasSuffix ".nix" n) (
            builtins.attrNames (builtins.readDir ./machines)
          );
          mkConfig =
            filename:
            let
              path = ./machines + "/${filename}";
              vars = import path;
            in
            {
              name = vars.machine.localHostName;
              value = mkDarwinSystem path;
            };
        in
        builtins.listToAttrs (map mkConfig machineFiles);

    };

}
