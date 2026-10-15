{
  lib,
  osConfig,
  pkgs,
  ...
}:

let

  tokenFile = osConfig.age.secrets."ghcr-token".path;
  jq = lib.getExe pkgs.jq;

  # Docker credential helper (credHelpers protocol) serving ghcr.io from the agenix secret, so the
  # registry token is never stored in ~/.docker/config.json. It refuses `store`: `docker login ghcr.io`
  # is not needed and cannot write the token back in plaintext.
  credentialHelper = pkgs.writeShellApplication {
    name = "docker-credential-agenix";
    text = ''
      case "''${1:-}" in
        get)
          read -r server
          case "$server" in
            ghcr.io | https://ghcr.io)
              ${jq} -cn --rawfile t ${tokenFile} --arg s "$server" \
                '{ServerURL: $s, Username: "pjan", Secret: ($t | rtrimstr("\n"))}'
              ;;
            *)
              echo "credentials not found in native keychain"
              exit 1
              ;;
          esac
          ;;
        store)
          cat >/dev/null
          echo "ghcr.io credentials are managed by agenix (nix-config); docker login is not needed" >&2
          exit 1
          ;;
        erase)
          cat >/dev/null
          ;;
        list)
          echo '{"ghcr.io":"pjan"}'
          ;;
        *)
          echo "usage: docker-credential-agenix get|store|erase|list" >&2
          exit 1
          ;;
      esac
    '';
  };

in
{

  home.packages = [ credentialHelper ];

  # Point docker at the helper for ghcr.io and drop any plaintext ghcr.io entry. Docker Desktop also
  # writes config.json, so it is edited in place instead of being managed as a file.
  home.activation.dockerCredentialHelper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="$HOME/.docker/config.json"
    current='{}'
    if [ -f "$cfg" ]; then current="$(cat "$cfg")"; fi
    if desired="$(printf '%s' "$current" | ${jq} '.credHelpers["ghcr.io"] = "agenix" | del(.auths["ghcr.io"])')"; then
      if [ "$current" != "$desired" ]; then
        # Write next to the target and rename, so config.json is never missing or half-written.
        writeDockerConfig() {
          mkdir -p "$HOME/.docker"
          local tmp
          tmp="$(mktemp "$cfg.XXXXXX")"
          printf '%s\n' "$desired" >"$tmp"
          chmod 600 "$tmp"
          mv -f "$tmp" "$cfg"
        }
        run writeDockerConfig
      fi
    else
      warnEcho "$cfg is not valid JSON; not configuring the ghcr.io credential helper"
    fi
  '';

}
