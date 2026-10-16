{
  config,
  lib,
  pkgs,
  ...
}:

let

  homeDirectory = config.home.homeDirectory;
  dataHome = config.xdg.dataHome;
  secretFile = "/run/agenix/aria2-rpc-secret";

in
{

  launchd.user.agents.aria2c = {
    script = ''
      if [[ ! -d ${dataHome}/aria ]]; then
        mkdir -p ${dataHome}/aria
      fi

      # Wait for agenix to decrypt the secret (activation may not have run yet).
      for i in $(seq 1 30); do
        [ -r "${secretFile}" ] && break
        sleep 1
      done

      ${pkgs.aria2}/bin/aria2c --enable-rpc \
        --dir ${homeDirectory}/Downloads \
        --log ${dataHome}/aria/aria2c.log \
        --check-integrity \
        --continue \
        --rpc-listen-port=6800 \
        --rpc-secret="$(cat "${secretFile}")"
    '';
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;
  };

}
