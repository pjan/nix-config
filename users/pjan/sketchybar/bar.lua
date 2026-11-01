local sbar   = require("sketchybar")
local colors = require("colors")

sbar.bar({
  position      = "top",
  height        = 39,
  color         = colors.bar_bg,
  topmost       = "window",
  padding_left  = 0,
  padding_right = 0,
})
