local sbar = require("sketchybar")

local clock = sbar.add("item", "clock", {
  position    = "right",
  update_freq = 10,
  label       = {
    font          = "SF Pro Display:Regular:13.0",
    padding_left  = 10,
    padding_right = 12,
  },
})

local function update_clock()
  sbar.exec("date '+%a %-d %b  %H:%M'", function(date)
    local str = (date:match("^(.-)%s*$") or "")
    -- Insert hair spaces (U+200A) after regular spaces for wider tracking
    str = str:gsub(" ", " \xE2\x80\x8A")
    clock:set({ label = { string = str } })
  end)
end

clock:subscribe("routine", update_clock)
update_clock()
