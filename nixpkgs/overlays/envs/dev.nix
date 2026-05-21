{ pkgs }:

pkgs.buildEnv {
  name = "dev-tools";
  paths = with pkgs; [
    circle-cli
    # Cloud-related tools and SDKs
    flyctl
    docker
    docker-compose
    google-cloud-sdk
  ];
}
