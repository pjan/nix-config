local sbar   = require("sketchybar")
local colors = require("colors")

local ICON_FONT = "Font Awesome 7 Free:Solid:14.0"

local cpu = sbar.add("item", "cpu", {
  position    = "right",
  update_freq = 5,
  icon = {
    drawing       = true,
    font          = ICON_FONT,
    string        = "\u{F2DB}",  -- fa-microchip
    color         = colors.white,
    padding_left  = 8,
    padding_right = 4,
  },
  label = {
    padding_left  = 0,
    padding_right = 8,
  },
})

local function update_cpu()
  sbar.exec("sketchybar-cpu-usage 2>/dev/null", function(out)
    local pct   = tonumber(out:match("(%d+)") or "0") or 0
    local color = pct > 80 and 0xFFFF6B6B or (pct > 50 and 0xFFFFAA55 or colors.white)
    cpu:set({
      icon  = { color = color },
      label = { string = pct .. "%", color = color },
    })
  end)
end

cpu:subscribe("routine", update_cpu)
update_cpu()
