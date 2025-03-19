{ pkgs }:

pkgs.buildEnv {
  name = "rust-tools";
  paths = with pkgs; [
    cargo-cache        # Display information on the cargo cache
  ];
}
