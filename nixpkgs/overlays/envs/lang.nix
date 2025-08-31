{ pkgs }:

pkgs.buildEnv {
  name = "lang-tools";
  paths = with pkgs; [
    autoconf
    automake
    clang
    cmake
    coreutils
    global
    gmp
    gnumake
    html-tidy
    idutils
    libcxx
    libtool
    llvm
    mpfr
    ninja
    ott
    ctags
    rtags
    sbcl
    loccount
  ];
}
