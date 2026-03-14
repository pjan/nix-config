{ pkgs }:

pkgs.buildEnv {
  name = "dev-tools";
  paths = with pkgs; [
    # Cloud-related tools and SDKs
    flyctl
    docker
    docker-compose
    google-cloud-sdk
    zed-editor
  ];
}
