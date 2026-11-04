local sbar = require("sketchybar")

local ICON_PNG = "/private/tmp/sketchybar-volume.png"

local volume = sbar.add("item", "volume", {
  position    = "right",
  update_freq = 1,
  width       = 16,
  y_offset    = 1,
  padding_right = 25,
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

local function update_volume()
  sbar.exec("osascript -e 'get volume settings'", function(out)
    local vol   = out:match("output volume:(%d+)")
    local muted = out:match("output muted:(%a+)")

    local sym, var_value
    if muted == "true" then
      sym = "speaker.slash.fill"
      var_value = 0.0
    else
      local n = tonumber(vol) or 0
      sym = "speaker.wave.3.fill"
      var_value = n / 100.0
    end

    sbar.exec("sketchybar-sf-icon " .. ICON_PNG .. " " .. sym .. " "
      .. string.format("%.2f", var_value) .. " FFFFFF 14 2>/dev/null", function()
      volume:set({
        background = { image = { string = ICON_PNG } },
      })
    end)
  end)
end

volume:subscribe("routine", update_volume)
update_volume()
