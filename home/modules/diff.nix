{ pkgs, lib, ... }:

{

  home.activation.showChanges = lib.hm.dag.entryAnywhere ''
    if [[ -v oldGenPath && -n "$oldGenPath" ]]; then
      echo "--- Home-manager changes ---" >&2
      ${pkgs.nvd}/bin/nvd diff "$oldGenPath" "$newGenPath" >&2 || true
    fi
  '';

}
