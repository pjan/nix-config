{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.handy
    pkgs.tinycast

    # Development Tools
    pkgs.ghostty-bin
    pkgs.ngrok

    # Utility Tools
    pkgs._1password-cli
    pkgs.the-unarchiver

    # Media Tools
    pkgs.iina

    # Browsers
    # pkgs.google-chrome

    # Productivity Tools
    # pkgs.stats
  ];

}
