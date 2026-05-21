self: super: {

  circle-cli = super.stdenv.mkDerivation rec {
    pname = "circle-cli";
    version = "0.0.3";

    src = super.fetchurl {
      url = "https://registry.npmjs.org/@circle-fin/cli/-/cli-${version}.tgz";
      hash = "sha256-/VkDGEGfwev/yLp5stoSPFjZFXV+TYduVWvQZMExPOg=";
    };

    nativeBuildInputs = [ super.makeWrapper ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/lib/circle-fin-cli $out/bin
      cp package/dist/index.js $out/lib/circle-fin-cli/index.js
      chmod +x $out/lib/circle-fin-cli/index.js
      makeWrapper ${super.nodejs}/bin/node $out/bin/circle \
        --add-flags "$out/lib/circle-fin-cli/index.js"
    '';

    meta = with super.lib; {
      description = "Circle CLI — command-line tool for interacting with Circle services";
      homepage = "https://www.npmjs.com/package/@circle-fin/cli";
      license = licenses.unfree;
      mainProgram = "circle";
    };
  };

}
