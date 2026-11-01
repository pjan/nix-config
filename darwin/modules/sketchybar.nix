_:

{

  services.sketchybar = {
    enable = true;
    config = ''
      #!/bin/bash

      # ── Bar ──────────────────────────────────────────────────────────────────
      # Solid black bar matching the notch height — full width, flush with top.
      # topmost=window: sits above app windows; system menu bar slides over it on hover.
      sketchybar --bar \
        position=top   \
        height=38      \
        color=0xFF000000 \
        topmost=window \
        padding_left=0 \
        padding_right=0

      # ── Defaults ─────────────────────────────────────────────────────────────
      sketchybar --default \
        padding_left=5  \
        padding_right=5 \
        icon.drawing=off \
        label.font="SF Pro:Regular:13.0" \
        label.color=0xFFFFFFFF

      # ── Aerospace workspace (left island) ────────────────────────────────────
      sketchybar --add event aerospace_workspace_change

      sketchybar --add item aerospace_workspace left
      sketchybar --set aerospace_workspace \
        label.padding_left=10 \
        label.padding_right=10 \
        label="$(aerospace list-workspaces --focused 2>/dev/null)" \
        script='WORKSPACE=''${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}; sketchybar --set $NAME label="$WORKSPACE"'
      sketchybar --subscribe aerospace_workspace aerospace_workspace_change

      # ── Clock — rightmost in right island ────────────────────────────────────
      sketchybar --add item clock right
      sketchybar --set clock \
        update_freq=10 \
        label.padding_left=10 \
        label.padding_right=10 \
        script="sketchybar --set \$NAME label=\"\$(date '+%a %b %e  %H:%M')\""

      # ── Battery — left of clock in right island ───────────────────────────────
      sketchybar --add item battery right
      sketchybar --set battery \
        update_freq=60 \
        label.padding_left=10 \
        label.padding_right=10 \
        script="PCT=\$(pmset -g batt | grep -Eo \"[0-9]+%\" | head -1); [ -n \"\$PCT\" ] && sketchybar --set \$NAME label=\"\$PCT\""

      # ── Left island bracket ───────────────────────────────────────────────────
      sketchybar --add bracket left_island aerospace_workspace
      sketchybar --set left_island \
        background.color=0xDD000000 \
        background.corner_radius=9  \
        background.height=32        \
        background.drawing=on

      # ── Right island bracket ──────────────────────────────────────────────────
      sketchybar --add bracket right_island battery clock
      sketchybar --set right_island \
        background.color=0xDD000000 \
        background.corner_radius=9  \
        background.height=32        \
        background.drawing=on

      sketchybar --update
    '';
  };

}
