{
  config,
  lib,
  pkgs,
  ...
}:

let

  direnv = lib.getExe config.programs.direnv.package;

  # `direnv hook zsh` output, generated at build time so a new shell doesn't
  # have to run direnv to install the hook.
  direnvZshHook = pkgs.runCommand "direnv-hook.zsh" { } ''
    ${direnv} hook zsh > $out
  '';

in
{

  programs.direnv = {

    enable = true;
    nix-direnv.enable = true;
    mise.enable = true;

    # Replaced by the pre-generated hook below.
    enableZshIntegration = false;

  };

  programs.zsh.initContent = lib.mkMerge [
    # Load the current directory's .envrc before the p10k instant prompt
    # (order 200, zsh.nix), so direnv's output doesn't push the prompt down.
    # See the powerlevel10k FAQ on direnv and instant prompt.
    (lib.mkOrder 150 ''
      emulate zsh -c "$(${direnv} export zsh)"
    '')

    # Same position as home-manager's integration (default order).
    ''
      source ${direnvZshHook}
    ''
  ];

}
