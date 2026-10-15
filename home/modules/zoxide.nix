{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.zoxide;

  # `zoxide init zsh` output, generated at build time so a new shell doesn't
  # have to run zoxide.
  zoxideZshInit = pkgs.runCommand "zoxide-init.zsh" { } ''
    ${lib.getExe cfg.package} init zsh ${lib.concatStringsSep " " cfg.options} > $out
  '';

in
{

  programs.zoxide = {
    enable = true;

    # Replaced by the pre-generated init below.
    enableZshIntegration = false;
  };

  # Same position as home-manager's integration: after compinit (order 851).
  programs.zsh.initContent = lib.mkOrder 851 ''
    source ${zoxideZshInit}
  '';

}
