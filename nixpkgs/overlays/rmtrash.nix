# rmtrash moves files to the freedesktop trash (~/.local/share/Trash), which
# Finder never empties. Give it a trash-put that moves files to the macOS Trash
# (/usr/bin/trash, macOS 15+) instead; rmtrash keeps handling the rm-style
# flags (-r, -f, -i, -v, ...).
self: super: {

  rmtrash = super.rmtrash.override {
    trash-cli = super.writeShellScriptBin "trash-put" ''
      # rmtrash calls this as `trash-put [--verbose] file...`.
      args=()
      if [ "$1" = --verbose ]; then
        args+=(--verbose)
        shift
      fi
      for file in "$@"; do
        # /usr/bin/trash has no `--`; keep names that start with - from being
        # read as options.
        case "$file" in
          -*) args+=("./$file") ;;
          *) args+=("$file") ;;
        esac
      done
      exec /usr/bin/trash "''${args[@]}"
    '';
  };

}
