local sbar   = require("sketchybar")
local colors = require("colors")

local ICON_FONT = "Font Awesome 7 Free:Solid:14.0"

local volume = sbar.add("item", "volume", {
  position    = "right",
  update_freq = 1,
  icon = {
    drawing       = true,
    font          = ICON_FONT,
    color         = colors.white,
    padding_left  = 8,
    padding_right = 4,
  },
  label = {
    padding_left  = 0,
    padding_right = 8,
  },
})

local function update_volume()
  sbar.exec("osascript -e 'get volume settings'", function(out)
    local vol   = out:match("output volume:(%d+)")
    local muted = out:match("output muted:(%a+)")

    if muted == "true" then
      volume:set({
        icon  = { string = "\u{F026}", color = colors.white_dim },  -- fa-volume-off
        label = { string = "mute",    color = colors.white_dim },
      })
    elseif vol then
      local n    = tonumber(vol) or 0
      local icon = n > 50 and "\u{F028}" or (n > 0 and "\u{F027}" or "\u{F026}")
      -- fa-volume-up / fa-volume-down / fa-volume-off
      volume:set({
        icon  = { string = icon, color = colors.white },
        label = { string = vol .. "%", color = colors.white },
      })
    end
  end)
end

volume:subscribe("routine", update_volume)
update_volume()
