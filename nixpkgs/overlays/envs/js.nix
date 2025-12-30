{ pkgs }:

pkgs.buildEnv {
  name = "js-tools";
  paths = with pkgs; [
    jiq
    jo
    jq
    jqp
    nodejs
    nodePackages.eslint
    # nodePackages.csslint
    nodePackages.prettier
    yq
  ];
}
