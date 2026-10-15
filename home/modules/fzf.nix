{
  config,
  lib,
  pkgs,
  ...
}:

let

  # `fzf --zsh` output, generated at build time so a new shell doesn't have to
  # run fzf (every process start costs ~10 ms under the endpoint agent).
  fzfZshInit = pkgs.runCommand "fzf-init.zsh" { } ''
    ${lib.getExe config.programs.fzf.package} --zsh > $out
  '';

in
{

  programs.fzf = {

    enable = true;

    tmux.enableShellIntegration = true;

    # Replaced by the pre-generated init below.
    enableZshIntegration = false;

  };

  # Same as home-manager's integration, including its position after oh-my-zsh
  # (order 910).
  programs.zsh.initContent = lib.mkOrder 910 ''
    if [[ $options[zle] = on ]]; then
      source ${fzfZshInit}
    fi
  '';

}
