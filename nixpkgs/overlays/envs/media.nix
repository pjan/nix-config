{ pkgs }:

pkgs.buildEnv {
  name = "media-tools";
  paths = with pkgs; [
    ffmpeg
    tidal-dl
  ];
}
