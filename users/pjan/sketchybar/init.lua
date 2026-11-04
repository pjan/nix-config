local sbar   = require("sketchybar")
local colors = require("colors")

sbar.begin_config()

require("bar")
require("default")
require("items.spaces")     -- workspace pills + left_island bracket
require("items.front_app")  -- active app name + icon

-- Standalone items at far right, matching macOS menu bar layout.
-- Added rightmost-first; visual order left→right: battery | volume | wifi | clock.
require("items.clock")
require("items.wifi")
require("items.volume")
require("items.battery")

-- Stats island — added rightmost-first; visual order left→right: cpu | memory | network.
require("items.network")
require("items.memory")
require("items.cpu")

sbar.add("bracket", "stats_island", { "cpu", "memory", "network" }, {
  background = {
    color         = colors.island,
    corner_radius = 9,
    height        = 32,
    drawing       = true,
  },
})

-- Right island — added rightmost-first; visual order left→right: dnd.
require("items.dnd")

sbar.add("bracket", "right_island", { "dnd" }, {
  background = {
    color         = colors.island,
    corner_radius = 9,
    height        = 32,
    drawing       = true,
  },
})

sbar.end_config()
sbar.event_loop()
