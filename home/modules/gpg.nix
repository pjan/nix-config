{ config, lib, pkgs, ... }:

let

in {

  programs.gpg = {

    enable = true;

    homedir = "${config.xdg.dataHome}/gnupg";

    settings = {
      personal-cipher-preferences = "AES256 AES192 AES CASTS";
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
    };

  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    pinentry.package = pkgs.pinentry_mac;
  };

}
