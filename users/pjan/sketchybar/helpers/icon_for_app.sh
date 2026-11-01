#!/bin/bash
# Usage: bash icon_for_app.sh <app_name>
# Prints the sketchybar-app-font ligature glyph for the given app name.
# Called via sbar.exec so does not need execute permission.
ICON_MAP="/etc/profiles/per-user/$USER/bin/icon_map.sh"
[ -f "$ICON_MAP" ] || exit 0
# shellcheck source=/dev/null
source "$ICON_MAP"
__icon_map "$1"
printf "%s" "$icon_result"
