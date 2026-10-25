{
  config,
  lib,
  pkgs,
  ...
}:

{

  programs.zsh = {

    enable = true;

    autocd = true;

    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      append = true;
      size = 100000;
      save = 100000;
      path = "${config.xdg.cacheHome}/zsh/history";
      ignoreDups = true;
      ignorePatterns = [
        "l"
        "l *"
        "ll"
        "lla"
        "la"
        "lt"
        "ls"
        "cd *"
        "z"
        "z *"
        "pwd"
        "exit"
        "date"
        "* --help"
        "rm *"
        "pkill *"
        "reboot"
      ];
      ignoreSpace = true;
    };

    oh-my-zsh = {
      enable = true;
      # One completion dump per zsh version. The default name includes the
      # hostname, which changes between networks and forces a rebuild.
      extraConfig = ''
        ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"
      '';
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ../files;
        file = "p10k.zsh";
      }
      # nix-shell starts zsh (this shell's binary) instead of bash, so the
      # prompt stays the same; --pure, --run and --command keep bash.
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh/plugins/zsh-nix-shell/nix-shell.plugin.zsh";
      }
    ];

    shellAliases = {
      diff = "${pkgs.difftastic}/bin/difft";

      # reload shell
      reload = "exec $SHELL -l";

      rm = "${pkgs.rmtrash}/bin/rmtrash";
      rmdir = "${pkgs.rmtrash}/bin/rmdirtrash";

      # secure remove
      srm = "${pkgs.thc-secure-delete}/bin/srm -vfr";

      # Run a speedtest
      speedtest = "${pkgs.speedtest-cli}/bin/speedtest";

      # nix shell
      shell = "_ns";
      ns = "_ns";

      # make a directory and cd into it
      mkd = "_mkd";
    }
    // lib.optionalAttrs config.editor.zed.enable {
      # open zeditor (nixpkgs), or the CLI bundled with Zed.app (brew cask)
      zed =
        if config.editor.zed.package != null then
          "${config.editor.zed.package}/bin/zeditor"
        else
          "/Applications/Zed.app/Contents/MacOS/cli";
      code = "zed";
    };

    initContent = lib.mkMerge [
      # Powerlevel10k instant prompt: draw the cached prompt immediately and
      # finish loading behind it. Must stay at the top of .zshrc; anything that
      # reads console input (passwords, prompts) has to go above it.
      (lib.mkOrder 200 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      (lib.mkBefore ''
        # Define variables for directories
        export PATH=$HOME/.local/share/bin:$PATH

        # vi is my editor
        export ALTERNATE_EDITOR=""
        export EDITOR="vi"
        export VISUAL="vi"

        # nix shortcuts
        _ns() {
          if [ "$#" -eq 0 ]; then
            echo "usage: ns <package> [package ...]"
            return 1
          fi

          NIX_PATH="nixpkgs=flake:nixpkgs" nix-shell -p "$@" --command 'exec zsh -l'
        }

        # nix develop always starts bash; start this shell's zsh binary instead
        # (same approach as zsh-nix-shell for nix-shell). Invocations that run a
        # command or build phase, or ask for a clean environment, are unchanged.
        nix() {
          if [[ $1 == develop ]] && (( ! ''${argv[(I)(-c|--command|-i|--ignore-environment|--phase|--unpack|--configure|--build|--check|--install|--installcheck)]} )); then
            local zsh_bin
            zsh_bin=$(/usr/sbin/lsof -p $$ -a -d txt -Fn 2>/dev/null | awk 'sub(/^n/, "") { print; exit }')
            command nix "$@" --command "''${zsh_bin:-zsh}"
          else
            command nix "$@"
          fi
        }

        # Make directory and cd into it
        _mkd(){
          ${pkgs.coreutils}/bin/mkdir -p "$1"
          cd "$1"
        }

        # Source local machine-specific config if present
        [[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"
      '')
    ];
  };

  home.file.".zshenv".text = lib.mkAfter ''
    export PATH="''${HOME}/.local/bin:''${PATH}"
  '';

}
