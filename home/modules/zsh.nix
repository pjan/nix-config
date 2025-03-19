{config, lib, pkgs, ...}:

let

in {

  programs.zsh = {

    enable = true;

    autocd = true;

    dotDir = ".config/zsh";

    history = {
      append = true;
      size = 100000;
      save = 100000;
      path = "${config.xdg.cacheHome}/zsh/history";
      ignoreDups = true;
      ignorePatterns = [ "l" "l *" "ll" "lla" "la" "lt" "ls" "cd *" ''"cd -"'' "z" "z *" "pwd" "exit" "date" ''"* --help"'' "rm *" "pkill *" "reboot" ];
      ignoreSpace = true;
    };

    oh-my-zsh = {
      enable = true;
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
    ];

    shellAliases = {
      diff = "${pkgs.difftastic}/bin/difft";

      # reload shell
      reload = "exec $SHELL -l";

      rm = "${pkgs.rmtrash}/bin/rmtrash";
      rmdir = "${pkgs.rmtrash}/bin/rmdirtrash";

      # secure remove
      srm = "${pkgs.srm}/bin/srm -vfr";

      # Run a speedtest
      speedtest = "${pkgs.speedtest-cli}/bin/speedtest";

      # nix shell
      shell = "_shell";

      # make a directory and cd into it
      mkd = "_mkd";
    };

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.local/share/bin:$PATH

      # Emacs is my editor
      export ALTERNATE_EDITOR=""
      export EDITOR="vi"
      export VISUAL="vi"

      # nix shortcuts
      _shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Make directory and cd into it
      _mkd(){
        ${pkgs.coreutils}/bin/mkdir -p $1
        cd $1
      }
    '';
  };

}
