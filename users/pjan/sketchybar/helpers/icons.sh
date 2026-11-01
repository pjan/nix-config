#!/bin/bash
# Usage: bash icons.sh <workspace_id>
# Prints sketchybar-app-font ligature glyphs for all apps in the workspace.
# Called via sbar.exec so does not need execute permission.
ICON_MAP="/etc/profiles/per-user/$USER/bin/icon_map.sh"
[ -f "$ICON_MAP" ] || exit 0
# shellcheck source=/dev/null
source "$ICON_MAP"
/run/current-system/sw/bin/aerospace list-windows --workspace "$1" --format '%{app-name}' 2>/dev/null \
  | sort -u | head -5 \
  | while IFS= read -r app; do
      [ -z "$app" ] && continue
      __icon_map "$app"
      printf "%s" "$icon_result"
    done
