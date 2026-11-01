#!/bin/bash
# Outputs 1 if a Focus/DND mode is active, 0 otherwise.
# Tries macOS 12+ DoNotDisturb assertions first, then legacy pref.
DB="$HOME/Library/DoNotDisturb/DB/Assertions.json"

if [ -f "$DB" ]; then
  active=$(python3 -c "
import json, sys
try:
    d = json.load(open('$DB'))
    records = d.get('storeAssertionRecords', [])
    print(1 if records else 0)
except Exception:
    print(0)
" 2>/dev/null)
  echo "${active:-0}"
  exit 0
fi

# Fallback: legacy doNotDisturb preference (macOS < 12)
dnd=$(defaults -currentHost read ~/Library/Preferences/com.apple.notificationcenterui doNotDisturb 2>/dev/null)
[ "$dnd" = "1" ] && echo 1 || echo 0
