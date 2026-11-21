{ lib, ... }:

{

  programs.ghostty = {
    enable = true;
    package = null; # installed via environment.systemPackages for Spotlight visibility
    settings = { };
  };

  # Ghostty's zsh integration appends a `%{…%}` prompt mark after every newline
  # in PS1, but only when PS1 is unchanged since its last precmd (always true on
  # the first prompt). Powerlevel10k's PS1 has newlines inside `${…}`
  # expansions; the injected `%}` closes them early and leaves stray `:-`/`}}`
  # on the first prompt. Pre-seeding Ghostty's saved PS1 makes it treat p10k's
  # PS1 as changed, so it skips the newline marks (as it already does for every
  # later prompt) but still adds its start/end marks.
  programs.zsh.initContent = lib.mkOrder 1400 ''
    [[ -n $GHOSTTY_RESOURCES_DIR ]] && typeset -g _ghostty_saved_ps1=
  '';

}
