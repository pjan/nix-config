{ lib, ... }:

{

  # Exclude /nix from Spotlight indexing.
  # /nix contains millions of store paths; indexing it causes slow cycles
  # and polluted results. .metadata_never_index tells mds to skip the tree.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    touch /nix/.metadata_never_index 2>/dev/null || true
  '';

}
