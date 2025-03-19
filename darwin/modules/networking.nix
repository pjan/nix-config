{ config, lib, pkgs, ... }:

let

in {

  networking = {
    hostName = config.networking.computerName;
    localHostName = config.networking.computerName;
    knownNetworkServices = [ "Wi-Fi" ];
    dns = [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

}
