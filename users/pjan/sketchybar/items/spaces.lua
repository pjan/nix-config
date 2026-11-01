local sbar   = require("sketchybar")
local colors = require("colors")

local HELPERS   = os.getenv("HOME") .. "/.config/sketchybar/helpers"
local AEROSPACE = "/run/current-system/sw/bin/aerospace"

-- Must match aerospace persistent-workspaces (excludes H, J, K, L — used as focus keys).
local WORKSPACES = {
  "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "A", "B", "C", "D", "E", "F", "G", "I", "M",
  "N", "O", "P", "Q", "R", "S", "T", "U", "V",
  "W", "X", "Y", "Z",
}

-- Create one item per workspace, all hidden initially.
local space_items = {}
for _, ws in ipairs(WORKSPACES) do
  local item = sbar.add("item", "space." .. ws, {
    position = "left",
    drawing  = false,
    icon = {
      string        = ws,
      font          = "SF Pro Text:Semibold:13.0",
      color         = colors.white,
      padding_left  = 8,
      padding_right = 2,
    },
    label = {
      string        = "",
      font          = "sketchybar-app-font:Regular:14.0",
      color         = colors.white,
      padding_left  = 0,
      padding_right = 8,
    },
    background = {
      color         = colors.focused_bg,
      corner_radius = 5,
      height        = 22,
      drawing       = false,
    },
    click_script = AEROSPACE .. " workspace " .. ws,
  })
  space_items[ws] = item
end

-- Query aerospace and refresh all workspace items.
-- Called on workspace change and front_app_switched (to catch window moves).
local function update_spaces()
  sbar.exec(
    AEROSPACE .. " list-workspaces --focused 2>/dev/null; echo '---'; " .. AEROSPACE .. " list-workspaces --monitor all --empty no 2>/dev/null",
    function(output)
      local focused  = ""
      local nonempty = {}
      local past_sep = false

      for raw in (output or ""):gmatch("[^\n]+") do
        local line = raw:match("^(.-)%s*$") or raw
        if not past_sep then
          if line == "---" then
            past_sep = true
          elseif line ~= "" then
            focused = line
          end
        else
          if line ~= "" then nonempty[line] = true end
        end
      end

      for _, ws in ipairs(WORKSPACES) do
        local item       = space_items[ws]
        local is_focused = (ws == focused)
        local visible    = is_focused or (nonempty[ws] == true)

        if not visible then
          item:set({ drawing = false })
        else
          item:set({
            drawing    = true,
            icon       = { drawing = true, color = is_focused and colors.white or colors.white_dim },
            background = { drawing = is_focused },
          })
          -- Fetch app icons asynchronously — one call per visible workspace.
          sbar.exec('/bin/bash "' .. HELPERS .. '/icons.sh" "' .. ws .. '"', function(icons)
            item:set({ label = { string = (icons or ""):match("^(.-)%s*$") or "" } })
          end)
        end
      end
    end
  )
end

-- Hidden observer: triggers a full refresh on relevant events.
-- update_freq catches window-to-workspace moves that don't change the focused
-- workspace (e.g. shift-opt-N) — those fire no AeroSpace event.
-- Keep this slow: every tick runs 2 + N aerospace CLI calls (N = visible
-- workspaces), and each call makes AeroSpace run a refresh session. At 1s this
-- cost AeroSpace ~7-15% CPU constantly; at 5s it is ~2%.
local observer = sbar.add("item", "spaces_observer", {
  position    = "left",
  drawing     = false,
  update_freq = 5,
})
observer:subscribe({ "aerospace_workspace_change", "front_app_switched", "routine" }, function()
  update_spaces()
end)

-- Populate initial state.
update_spaces()

-- Left island bracket spans all workspace items.
-- Hidden items collapse to zero width so the pill shrinks when workspaces are empty.
local space_names = {}
for _, ws in ipairs(WORKSPACES) do
  table.insert(space_names, "space." .. ws)
end

sbar.add("bracket", "left_island", space_names, {
  background = {
    color         = colors.island,
    corner_radius = 9,
    height        = 32,
    drawing       = true,
  },
})
