{ pkgs }:

pkgs.buildEnv {
  name = "git-tools";
  paths = with pkgs; [
    act # run github apps locall
    colordiff
    diffstat
    diffutils
    gitAndTools.ghi
    gitAndTools.gist
    gitAndTools.git-cliff
    gitAndTools.git-crypt
    (lowPrio gitAndTools.git-fame)
    gitAndTools.git-secret
    gitAndTools.gitRepo
    gitAndTools.hub
    gitAndTools.tig
    # gitAndTools.git-annex
    # gitAndTools.git-annex-remote-rclone
    patch
    patchutils
  ];
}
