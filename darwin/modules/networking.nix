{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

{

  networking = {
    localHostName = vars.machine.localHostName;
    knownNetworkServices = [ "Wi-Fi" ];
    # [] = DNS from DHCP/VPN. Set fixed servers per machine in machines/<hostname>.nix.
    dns = vars.machine.dns or [ ];
  }
  // lib.optionalAttrs (vars.machine.hostname != null && vars.machine.hostname != "") {
    hostName = vars.machine.hostname;
  };

}
