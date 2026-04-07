{ lib, pkgs, ... }:

{

  system.activationScripts.postActivation.text = lib.mkBefore ''
    if [[ -e /run/current-system ]]; then
      echo "--- Darwin system changes ---" >&2
      ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig" >&2 || true
    fi
  '';

}
