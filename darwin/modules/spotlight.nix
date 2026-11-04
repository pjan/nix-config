{ lib, ... }:

{

  # Exclude /nix and /Applications/Nix Apps from Spotlight indexing.
  # /nix contains millions of store paths; indexing it causes slow cycles
  # and polluted results. Nix Apps are excluded to prevent duplicate results
  # for apps that are copied to /Applications/ for proper code signing.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    touch /nix/.metadata_never_index 2>/dev/null || true
    touch "/Applications/Nix Apps/.metadata_never_index" 2>/dev/null || true
  '';

}
