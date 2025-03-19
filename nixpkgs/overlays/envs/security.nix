{ pkgs }:

pkgs.buildEnv {
  name = "security-tools";
  paths = with pkgs; [
    age                 #
    age-plugin-yubikey  #
    apg                 # Automated password generator
    b3sum               # BLAKE3 hash generator
    gnupg               #
    keybase             #
    kbfs                #
    paperkey            #
  ];
}
