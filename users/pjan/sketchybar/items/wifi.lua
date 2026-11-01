local sbar = require("sketchybar")

local ICON_PNG = "/private/tmp/sketchybar-wifi.png"

local wifi = sbar.add("item", "wifi", {
  position    = "right",
  drawing     = false,
  update_freq = 30,
  width       = 16,
  icon        = { drawing = false },
  label       = { drawing = false },
  background  = {
    drawing = true,
    color   = 0x00000000,
    image   = {
      string = ICON_PNG,
      scale  = 0.5,
    },
  },
})

local function update_wifi()
  sbar.exec("sketchybar-wifi-icon " .. ICON_PNG .. " FFFFFF 15 2>/dev/null", function(out)
    out = (out or ""):match("^(.-)%s*$")
    wifi:set({
      drawing    = (out ~= "off" and out ~= ""),
      background = { image = { string = ICON_PNG } },
    })
  end)
end

wifi:subscribe("routine", update_wifi)
update_wifi()
