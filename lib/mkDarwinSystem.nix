# Build a nix-darwin system configuration for a machine with one or more users.
#
# Usage in flake.nix:
#   mkDarwinSystem = import ./lib/mkDarwinSystem.nix { inherit inputs overlays; };
#   darwinConfigurations.MacBookPro = mkDarwinSystem ./machines/macbook-pjan.nix;

{ inputs, overlays }:

machineConfigPath:

let

  vars = import machineConfigPath;
  system = "aarch64-darwin";

  # Map of username → home-manager module path (defined in users/default.nix).
  userModules = import ../users;

  # Per-user home-manager configuration: import the user module for each
  # username listed in vars.machine.users, merging in any machine-specific
  # per-user modules from vars.home.userModules.<username>.
  perUserMachineModules = vars.home.userModules or { };

  homeManagerUsers = builtins.listToAttrs (
    map (username: {
      name = username;
      value = {
        imports = [ userModules.${username} ] ++ (perUserMachineModules.${username} or [ ]);
      };
    }) vars.machine.users
  );

  # Collect all .nix files from the shared home modules directory.
  sharedHomeModules = inputs.nixpkgs.lib.filter (n: inputs.nixpkgs.lib.strings.hasSuffix ".nix" n) (
    inputs.nixpkgs.lib.filesystem.listFilesRecursive ../home/modules
  );

in

inputs.darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit inputs overlays vars;
    inherit (inputs)
      homebrew-bundle
      homebrew-core
      homebrew-cask
      homebrew-subtlesoft
      ;
    inherit (inputs) secrets;
  };
  modules = [
    # home-manager integration
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs vars; };
        backupFileExtension = "hm-backup";

        # Shared home-manager modules — every user gets these.
        sharedModules = [
          # Export XDG environment variables (macOS doesn't set them).
          (
            { config, ... }:
            {
              home.sessionVariables = {
                XDG_CACHE_HOME = config.xdg.cacheHome;
                XDG_CONFIG_HOME = config.xdg.configHome;
                XDG_DATA_HOME = config.xdg.dataHome;
                XDG_STATE_HOME = config.xdg.stateHome;
              };
            }
          )
          # riptide home-manager module
          inputs.riptide.homeManagerModules.default
          # Home-manager option declarations (user.*, etc.)
          ../home/overlays
        ]
        ++ sharedHomeModules
        ++ (vars.home.extraModules or [ ]);

        users = homeManagerUsers;
      };
    }

    # nix-homebrew
    inputs.nix-homebrew.darwinModules.nix-homebrew

    # agenix
    inputs.agenix.darwinModules.default

    # System-level darwin modules
    ../darwin

    # Homebrew (nix-homebrew configuration)
    ../brew
  ]
  ++ (vars.darwin.extraModules or [ ]);
}
