local sbar = require("sketchybar")

local clock = sbar.add("item", "clock", {
  position    = "right",
  update_freq = 10,
  label       = {
    padding_left  = 10,
    padding_right = 10,
  },
})

local function update_clock()
  sbar.exec("date '+%a %b %e  %H:%M'", function(date)
    clock:set({ label = { string = date:match("^(.-)%s*$") or "" } })
  end)
end

clock:subscribe("routine", update_clock)
update_clock()
