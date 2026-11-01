local sbar   = require("sketchybar")
local colors = require("colors")

sbar.default({
  padding_left  = 5,
  padding_right = 5,
  icon          = { drawing = false },
  label         = {
    font  = "SF Pro Text:Regular:13.0",
    color = colors.white,
  },
})
