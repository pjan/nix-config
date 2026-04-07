{ pkgs }:

pkgs.buildEnv {
  name = "git-tools";
  paths = with pkgs; [
    act # run github apps locall
    colordiff
    diffstat
    diffutils
    gh
    ghi
    gist
    git-cliff
    git-crypt
    (lib.lowPrio git-fame)
    git-secret
    gitRepo
    hub
    tig
    # git-annex
    # git-annex-remote-rclone
    patch
    patchutils
  ];
}
