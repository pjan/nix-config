local sbar   = require("sketchybar")
local colors = require("colors")

sbar.default({
  padding_left  = 5,
  padding_right = 5,
  y_offset      = 1,
  icon          = { drawing = false, y_offset = 1 },
  label         = {
    font     = "SF Pro Text:Regular:13.0",
    color    = colors.white,
    y_offset = 1,
  },
})
