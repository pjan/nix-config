{ pkgs }:

pkgs.buildEnv {
  name = "network-tools";
  paths = with pkgs; [
    adns
    aria2
    bandwhich
    cacert
    docker
    dnsutils
    fping
    httpie
    httrack
    hostname
    iftop
    iperf
    lftp
    mitmproxy
    mtr
    # ngrep
    nmap
    openssl
    openvpn
    pdnsd
    privoxy
    rclone
    rsync
    # siege
    sipcalc
    spiped
    whois
    w3m
    wget
  ];
}
