{
  user.email = "ci@example.com";
  user.username = "ci-user";
  user.fullName = "CI User";
  user.gitName = "CI User";

  networking.computerName = "ci-machine";
  networking.localHostName = "ci-machine";
  networking.hostName = null;

  nix.sslCertFile = null;

  brew.enable = false;
  brew.cleanup = null;

  shell.sessionPath = [];
}
