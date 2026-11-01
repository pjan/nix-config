local sbar   = require("sketchybar")
local colors = require("colors")

local HELPERS   = os.getenv("HOME") .. "/.config/sketchybar/helpers"
local ICON_FONT = "Font Awesome 7 Free:Solid:14.0"

local memory = sbar.add("item", "memory", {
  position    = "right",
  update_freq = 30,
  icon = {
    drawing       = true,
    font          = ICON_FONT,
    string        = "\u{F538}",  -- fa-memory
    color         = colors.white,
    padding_left  = 8,
    padding_right = 4,
  },
  label = {
    padding_left  = 0,
    padding_right = 8,
  },
})

local function update_memory()
  sbar.exec('/bin/bash "' .. HELPERS .. '/memory.sh"', function(out)
    local pct   = tonumber(out:match("(%d+)") or "0") or 0
    local color = pct > 90 and 0xFFFF6B6B or (pct > 75 and 0xFFFFAA55 or colors.white)
    memory:set({
      icon  = { color = color },
      label = { string = pct .. "%", color = color },
    })
  end)
end

memory:subscribe("routine", update_memory)
update_memory()
