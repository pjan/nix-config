local sbar   = require("sketchybar")
local colors = require("colors")

local ICON_FONT = "Font Awesome 7 Free:Solid:14.0"

local battery = sbar.add("item", "battery", {
  position    = "right",
  update_freq = 60,
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

local function update_battery()
  sbar.exec("pmset -g batt", function(batt_info)
    local pct   = batt_info:match("(%d+)%%")
    local state = batt_info:match("%d+%%; (%a+)")
    if not pct then return end

    local n          = tonumber(pct) or 0
    local icon_color = colors.white
    local lbl_color  = colors.white
    local icon

    if state == "charging" then
      icon = "\u{F0E7}"             -- fa-bolt
    elseif state == "charged" then
      icon = "\u{F240}"             -- fa-battery-full
    elseif n > 75 then
      icon = "\u{F240}"             -- fa-battery-full
    elseif n > 50 then
      icon = "\u{F241}"             -- fa-battery-three-quarters
    elseif n > 25 then
      icon = "\u{F242}"             -- fa-battery-half
    elseif n > 10 then
      icon = "\u{F243}"             -- fa-battery-quarter
      icon_color = 0xFFFFAA55       -- orange warning
      lbl_color  = 0xFFFFAA55
    else
      icon = "\u{F244}"             -- fa-battery-empty
      icon_color = 0xFFFF6B6B       -- red critical
      lbl_color  = 0xFFFF6B6B
    end

    battery:set({
      icon  = { string = icon, color = icon_color },
      label = { string = pct .. "%", color = lbl_color },
    })
  end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, update_battery)
update_battery()
