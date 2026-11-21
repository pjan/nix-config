# mitmproxy-rs was bumped to 0.12.16 without updating the mitmproxy-macos wheel
# hash, so the fetch fails. Fix: https://github.com/NixOS/nixpkgs/pull/591156
# Only applies while nixpkgs still has the stale hash; delete once it's merged.
_: super: {
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (_: pySuper: {
      mitmproxy-macos = pySuper.mitmproxy-macos.overridePythonAttrs (
        old:
        if
          old.version == "0.12.16"
          && old.src.outputHash == "sha256-7VaT+JsMvR0qjFoxuu0r16dLCq1oZy4IREwYaMOPSfg="
        then
          {
            src = old.src.overrideAttrs { outputHash = "sha256-ruw6Tl0NG8XJiyltwszNaXAxiOWUYlDU9n8eaxSYI+A="; };
          }
        else
          { }
      );
    })
  ];
}
