{ python3, lib, ffmpeg }:

let

  python = python3.override {
    packageOverrides = self: super: {
      aigpy = self.buildPythonPackage rec {
        pname = "aigpy";
        version = "2020.5.4.0";

        src = self.fetchPypi {
          inherit pname version;
          sha256 = "0m9k4ladifv4lx4k00f7fjnym91nlwzlygwxf0ifr4g9wmddbc5r";
        };

        doCheck = false;

        meta = with lib; {
          homepage = "https://github.com/yaronzz/AIGPY";
          description = "";
          license = licenses.mit;
        };

        propagatedBuildInputs =
          [ super.requests super.configparser super.colorama super.mutagen ];
      };

      pydub = self.buildPythonPackage rec {
        pname = "pydub";
        version = "0.24.1";

        src = self.fetchPypi {
          inherit pname version;
          sha256 = "0sfwfq7yjv4bl3yqbmizszscafvwf4zr40hzbsy7rclvzyznh333";
        };

        doCheck = false;

        meta = with lib; {
          homepage = "https://github.com/jiaaro/pydub";
          description =
            "Pydub lets you do stuff to audio in a way that isn't stupid.";
          license = licenses.mit;
        };
      };

      pycryptodome = self.buildPythonPackage rec {
        pname = "pycryptodome";
        version = "3.9.7";

        src = self.fetchPypi {
          inherit pname version;
          sha256 = "1wk9p1h76drzxpsizx1s1p60jshql8c3vhvpq6rpk48pdldx5bgi";
        };

        doCheck = false;

        meta = with lib; {
          homepage = "https://github.com/Legrandin/pycryptodome";
          description =
            "PyCryptodome is a self-contained Python package of low-level cryptographic primitives.";
          license = licenses.bsd2;
        };
      };

      ffmpeg = self.buildPythonPackage rec {
        pname = "ffmpeg";
        version = "1.4";

        src = self.fetchPypi {
          inherit pname version;
          sha256 = "1fdml3drkwcppgwwgpb01k55v0a7jwcc4cw4jcwivwhgi4n6jcb9";
        };

        doCheck = false;

        meta = with lib; {
          homepage = "https://www.ffmpeg.org/";
          description =
            "PyCryptodome is a self-contained Python package of low-level cryptographic primitives.";
          license = licenses.lgpl21;
        };
      };
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "tidal_dl_ng";
  version = "0.24.6";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "cb4e60875cfc59be3b0539dcbaf0370816b6cbb51cc87e01e7b127675199f3bc";
  };

  # propagatedBuildInputs = [
  #   python.pkgs.aigpy
  #   python.pkgs.pydub
  #   python.pkgs.pycryptodome
  #   python.pkgs.ffmpeg
  #   ffmpeg
  # ];

  doCheck = false; # attempts to access various URLs

  meta = with lib; {
    description =
      "Tidal-dl-ng is an application that lets you download videos and tracks from Tidal.";
    homepage = "https://github.com/exislow/tidal-dl-ng";
    license = licenses.asl20;
  };
}
