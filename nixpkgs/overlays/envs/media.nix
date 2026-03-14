{ pkgs }:

pkgs.buildEnv {
  name = "media-tools";
  paths = with pkgs; [
    beatport-dl
    ffmpeg
    mkvtoolnix
    tidal-dl
  ];
}
