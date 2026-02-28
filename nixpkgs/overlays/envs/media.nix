{ pkgs }:

pkgs.buildEnv {
  name = "media-tools";
  paths = with pkgs; [
    beatport-dl
    ffmpeg
    tidal-dl
    bpm-tag
  ];
}
