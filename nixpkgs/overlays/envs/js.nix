{ pkgs }:

pkgs.buildEnv {
  name = "js-tools";
  paths = with pkgs; [
    jiq
    jo
    jq
    jqp
    nodejs
    eslint
    # csslint
    prettier
    yq
  ];
}
