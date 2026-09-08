self: super: {

  circle-cli = super.buildNpmPackage rec {
    pname = "circle-cli";
    version = "0.0.3";

    src = super.fetchurl {
      url = "https://registry.npmjs.org/@circle-fin/cli/-/cli-${version}.tgz";
      hash = "sha256-/VkDGEGfwev/yLp5stoSPFjZFXV+TYduVWvQZMExPOg=";
    };

    # package-lock.json generated from the tarball's package.json with devDependencies
    # stripped — they include private @circlefin-scoped packages not on the public registry.
    postPatch = ''
      cp ${./circle-fin-cli-lock.json} package-lock.json
      ${super.jq}/bin/jq 'del(.devDependencies)' package.json > package.json.tmp
      mv package.json.tmp package.json
    '';

    npmDepsHash = "sha256-ToWy0Q5snPWnA5fpRExz/XalzBYYt+d0f5+FY+GdxYk=";

    npmFlags = [ "--omit=dev" "--legacy-peer-deps" ];

    dontNpmBuild = true;

    unpackPhase = ''
      tar -xzf $src --strip-components=1
    '';

    meta = with super.lib; {
      description = "Circle CLI — command-line tool for interacting with Circle services";
      homepage = "https://www.npmjs.com/package/@circle-fin/cli";
      license = licenses.unfree;
      mainProgram = "circle";
    };
  };

}
