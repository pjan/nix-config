self: super: {

  bmad-method = super.buildNpmPackage rec {
    pname = "bmad-method";
    version = "6.2.2";

    src = super.fetchFromGitHub {
      owner = "bmad-code-org";
      repo = "BMAD-METHOD";
      rev = "v${version}";
      hash = "sha256-Mehg+QMPZj5SqZIRn87xzlJ2wtExAn5566A1x2gL5Wk=";
    };

    npmDepsHash = "sha256-PnZNGD+LfbE6kqfiom5ClLtNVL7GVYnVjtrCvlY5JAk=";

    dontNpmBuild = true;

    meta = with super.lib; {
      description = "Breakthrough Method for Agile AI-driven Development";
      homepage = "https://github.com/bmad-code-org/BMAD-METHOD";
      license = licenses.mit;
      mainProgram = "bmad";
    };
  };

}
