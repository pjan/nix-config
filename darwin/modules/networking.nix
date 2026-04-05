{ config, lib, pkgs, vars, ... }:

let

in {

  networking = {
    localHostName = vars.networking.localHostName;
    knownNetworkServices = [ "Wi-Fi" ];
    dns = [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  }
  // lib.optionalAttrs (vars.networking.hostName != null && vars.networking.hostName != "") {
    hostName = vars.networking.hostName;
  };

}
