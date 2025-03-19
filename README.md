# nix-config: nix configuration for mac machines

## Layout

```
.
├─┬─ brew              # Top folder with homebrew configuration
│ ├── brews.nix        # List of homebrew brews
│ ├── casks.nix        # List of homebrew casks
│ └── default.nix
├─┬─ darwin            # Top folder with nix-darwin configuration
│ ├─┬─ modules         # Folder with all the module configurations
│ │ └─ ...
│ ├─┬─ overlays        # Folder with nix-darwin extensions and overlays
│ │ └─ ...
│ └── default.nix
├─┬─ home              # Top folder with home-manager configuration
│ ├─┬─ files           # Folder with all the (template) files used
│ │ └─ ...
│ ├─┬─ modules         # Folder with all the module configurations
│ │ └─ ...
│ ├─┬─ overlays        # Folder with nix-darwin extensions and overlays
│ │ └─ ...
│ ├─┬─ packages        # Folder with configuration for packages to be installed
│ │ └─ ...
│ └── default.nix
├─┬─ nixpkgs           # Top folder for all nixpkgs configurations
│ ├─┬─ overlays        # Folder for all the nixpkgs overlays and extentions
│ │ └─ ...
│ └── ...
├── flake.nix          # The flake file for this repo
└── README.md          # This file
```
