local sbar   = require("sketchybar")
local colors = require("colors")

local ICON_FONT = "Font Awesome 7 Free:Solid:14.0"
local INTERVAL  = 2  -- must match update_freq

-- Upvalues persist across callbacks for delta calculation.
local prev_in  = 0
local prev_out = 0

local network = sbar.add("item", "network", {
  position    = "right",
  update_freq = INTERVAL,
  icon = {
    drawing       = true,
    font          = ICON_FONT,
    string        = "\u{F0EC}",  -- fa-exchange
    color         = colors.white,
    padding_left  = 8,
    padding_right = 4,
  },
  label = {
    font          = "SF Pro Text:Regular:11.0",
    padding_left  = 0,
    padding_right = 8,
  },
})

local function fmt(bps)
  bps = math.max(0, bps)
  if bps >= 1024 * 1024 then
    return string.format("%.1fM", bps / (1024 * 1024))
  elseif bps >= 1024 then
    return string.format("%.0fK", bps / 1024)
  else
    return string.format("%.0fB", bps)
  end
end

local function update_network()
  sbar.exec("/usr/sbin/netstat -I en0 -b -n 2>/dev/null | awk 'NR==2{print $7, $10}'", function(out)
    local b_in, b_out = out:match("(%d+)%s+(%d+)")
    if not b_in then return end

    b_in  = tonumber(b_in)
    b_out = tonumber(b_out)

    if prev_in > 0 then
      local rate_in  = math.max(0, b_in  - prev_in)  / INTERVAL
      local rate_out = math.max(0, b_out - prev_out) / INTERVAL
      network:set({
        label = { string = "↑ " .. fmt(rate_out) .. "  ↓ " .. fmt(rate_in) },
      })
    end

    prev_in  = b_in
    prev_out = b_out
  end)
end

network:subscribe("routine", update_network)
update_network()
