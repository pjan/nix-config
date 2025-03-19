{ pkgs }:

pkgs.buildEnv {
  name = "system-tools";
  paths = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.nl
    bash-completion
    bashInteractive
    bat              # alternative to cat
    coreutils
    csvkit
    ctop
    curl
    direnv
    exiv2
    fd               # alternative to find
    fdupes
    findutils
    fswatch
    fzf
    gawk
    gettext
    gnugrep
    gnuplot
    gnused
    gnutar
    htop
    imgcat
    killall
    less
    lsof
    lzip
    lzop
    multitail
    p7zip
    pass
    parallel
    postgresql
    procps
    psrecord
    pstree
    pv
    renameutils
    ripgrep
    rlwrap
    rmtrash
    scc
    screen
    shfmt
    silver-searcher
    srm
    sqlite
    sqlite-analyzer
    sqldiff
    # tidal-dl
    time
    tree
    tree-sitter
    # tsvutils
    unixtools.ifconfig
    unixtools.netstat
    unixtools.ping
    unixtools.route
    unixtools.top
    unrar
    unzip
    watch
    xz
    yt-dlp
    zbar
    zip

    # z3
  ];
}
