{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let

  gitName = "pjan vandaele";
  gitEmail = config.user.email;
  sslCertFile = vars.nix.sslCertFile;

  # Public half of the "Github (pjan)" SSH key in 1Password; signs commits and tags.
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0L6BtkYnTzCxl5L2UlPsp18Im68t0mLE56NhZQZMWK";

in
{

  programs.git = {
    settings = {
      user = {
        name = "${gitName}";
        email = "${gitEmail}";
      };

      credential.helper = "osxkeychain";

      http = {
        # Same CA bundle as Nix (includes corporate roots, e.g. Zscaler) when configured.
        sslCAinfo =
          if sslCertFile != null then sslCertFile else "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        sslverify = true;
      };
    };

    # Sign with the SSH key in 1Password (Touch ID per signature); op-ssh-sign talks to the app
    # directly, independent of SSH_AUTH_SOCK/IdentityAgent.
    signing = {
      format = "ssh";
      key = signingKey;
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      signByDefault = true;
      # Lets `git log --show-signature` / `git verify-commit` verify locally.
      allowedSigners = ''
        ${gitEmail} namespaces="git" ${signingKey}
      '';
    };

  };

}
