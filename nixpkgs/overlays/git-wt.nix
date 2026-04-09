self: super: {

  git-wt = super.buildGoModule rec {
    pname = "git-wt";
    version = "2.0.1";

    src = super.fetchFromGitHub {
      owner = "ahmedelgabri";
      repo = "git-wt";
      rev = "v${version}";
      hash = "sha256-VOd2wVXxc+OPziCScPC326qHhxEmDNRpuLjYkXwsHOY=";
    };

    vendorHash = "sha256-0nGYE3qHmkMQJMyEfeU8lMORFNGdKHA78qxV49Goxks=";

    nativeBuildInputs = [ super.git ];

    meta = with super.lib; {
      description = "Git worktree manager";
      homepage = "https://github.com/ahmedelgabri/git-wt";
      license = licenses.mit;
      mainProgram = "git-wt";
    };
  };

}
