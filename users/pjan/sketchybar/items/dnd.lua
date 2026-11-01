local sbar   = require("sketchybar")
local colors = require("colors")

local HELPERS = os.getenv("HOME") .. "/.config/sketchybar/helpers"

local dnd = sbar.add("item", "dnd", {
  position    = "right",
  drawing     = false,
  update_freq = 30,
  label = {
    string        = "⊘",
    padding_left  = 8,
    padding_right = 8,
    color         = colors.white_dim,
  },
})

local function update_dnd()
  sbar.exec('/bin/bash "' .. HELPERS .. '/dnd.sh"', function(out)
    local active = (out:match("^%s*1%s*$") ~= nil)
    dnd:set({ drawing = active })
  end)
end

dnd:subscribe("routine", update_dnd)
update_dnd()
