{ config, lib, pkgs, vars, ... }:

let

in {

  networking = {
    localHostName = vars.networking.localHostName;
    knownNetworkServices = [ "Wi-Fi" ];
    # [] = DNS from DHCP/VPN. Set fixed servers per machine with networking.dns in config.nix;
    # `or` keeps machines whose config.nix predates the setting evaluating.
    dns = vars.networking.dns or [ ];
  }
  // lib.optionalAttrs (vars.networking.hostName != null && vars.networking.hostName != "") {
    hostName = vars.networking.hostName;
  };

}
