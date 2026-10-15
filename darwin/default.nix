{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let

  homeDirectory = config.home.homeDirectory;
  userName = vars.user.username;
  userFullName = vars.user.fullName;
  userEmail = vars.user.email;
  computerName = vars.networking.computerName;

in
{

  user.username = userName;
  user.fullName = userFullName;
  user.email = userEmail;
  networking.computerName = computerName;

  users.users.${userName} = {
    name = userName;
    home = homeDirectory;
    isHidden = false;
    shell = pkgs.zsh;
  };

  # home-manager sets up completion (oh-my-zsh) and the prompt (powerlevel10k)
  # per user. Doing it in /etc/zshrc too runs compinit twice and shares one
  # .zcompdump between /bin/zsh and nix zsh, which rebuild it in turn.
  programs.zsh.enableGlobalCompInit = false;
  programs.zsh.enableBashCompletion = false;
  programs.zsh.promptInit = "";

  system.stateVersion = 5;
  system.checks.verifyNixPath = false;
  system.primaryUser = userName;

  imports = [
    ./overlays
  ]
  ++ lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive ./modules)
  ++ lib.optional (builtins.pathExists ./overrides.nix) ./overrides.nix;

}
