self: super:

let

in {

  tools = {
    dev        = self.callPackage ./envs/dev.nix      { };
    git        = self.callPackage ./envs/git.nix      { };
    js         = self.callPackage ./envs/js.nix       { };
    lang       = self.callPackage ./envs/lang.nix     { };
    media      = self.callPackage ./envs/media.nix    { };
    network    = self.callPackage ./envs/network.nix  { };
    nix        = self.callPackage ./envs/nix.nix      { };
    rust       = self.callPackage ./envs/rust.nix     { };
    security   = self.callPackage ./envs/security.nix { };
    system     = self.callPackage ./envs/system.nix   { };
  };

}
