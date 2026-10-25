{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let

  primaryUser = vars.machine.primaryUser;
  computerName = vars.machine.computerName;

in
{

  user.username = primaryUser;
  networking.computerName = computerName;

  users.users = builtins.listToAttrs (
    map (username: {
      name = username;
      value = {
        name = username;
        home = "/Users/${username}";
      };
    }) vars.machine.users
  );

  # home-manager sets up completion (oh-my-zsh) and the prompt (powerlevel10k)
  # per user. Doing it in /etc/zshrc too runs compinit twice and shares one
  # .zcompdump between /bin/zsh and nix zsh, which rebuild it in turn.
  programs.zsh = {
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  system.stateVersion = 5;
  system.primaryUser = primaryUser;

  imports = [
    ./overlays
  ]
  ++ lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive ./modules)
  ++ lib.optional (builtins.pathExists ./overrides.nix) ./overrides.nix;

}
