{ pkgs }:

pkgs.buildEnv {
  name = "nix-tools";
  paths = with pkgs; [
    lorri
    nix-bash-completions
    nix-diff
    nix-index
    nix-info
    nix-prefetch-scripts
    # nixpkgs-fmt
    # nixfmt
  ];
}
