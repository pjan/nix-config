local sbar   = require("sketchybar")
local colors = require("colors")

local ICON_PNG = "/private/tmp/sketchybar-battery.png"

-- Two items added rightmost-first: pct appears right of icon.
local battery_pct = sbar.add("item", "battery_pct", {
  position      = "right",
  padding_left  = 0,
  padding_right = 2,
  icon          = { drawing = false },
  label         = {
    font          = "SF Pro Display:Regular:13.0",
    color         = colors.white,
    padding_left  = 0,
    padding_right = 0,
  },
})

local battery_icon = sbar.add("item", "battery_icon", {
  position      = "right",
  update_freq   = 60,
  width         = 28,
  y_offset      = 1,
  padding_left  = 2,
  padding_right = 0,
  icon          = { drawing = false },
  label         = { drawing = false },
  background    = {
    drawing = true,
    color   = 0x00000000,
    image   = {
      string = ICON_PNG,
      scale  = 0.5,
    },
  },
})

local function update_battery()
  sbar.exec("pmset -g batt", function(batt_info)
    local pct   = batt_info:match("(%d+)%%")
    local state = batt_info:match("%d+%%; (%a+)")
    if not pct then return end

    local n        = tonumber(pct) or 0
    local on_power = batt_info:match("'AC Power'") ~= nil
    local sym      = on_power and "battery.100percent.bolt" or "battery.100percent"
    local color    = "FFFFFF"

    -- macOS thresholds: yellow ≤20%, red ≤10% (only on battery)
    if not on_power then
      if n <= 10 then
        color = "FF6B6B"
      elseif n <= 20 then
        color = "FFAA55"
      end
    end

    local var_value = n / 100.0
    local lbl_color = color == "FFFFFF" and colors.white
                   or color == "FFAA55" and 0xFFFFAA55
                   or 0xFFFF6B6B

    sbar.exec("sketchybar-sf-icon " .. ICON_PNG .. " " .. sym .. " "
      .. string.format("%.2f", var_value) .. " " .. color .. " 18 2>/dev/null", function()
      battery_icon:set({
        background = { image = { string = ICON_PNG } },
      })
    end)

    battery_pct:set({
      label = { string = pct .. "%", color = lbl_color },
    })
  end)
end

battery_icon:subscribe({ "routine", "power_source_change", "system_woke" }, update_battery)
update_battery()
