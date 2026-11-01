local sbar   = require("sketchybar")
local colors = require("colors")

local HELPERS = os.getenv("HOME") .. "/.config/sketchybar/helpers"

local front_app = sbar.add("item", "front_app", {
  position = "left",
  icon = {
    string        = "",
    font          = "sketchybar-app-font:Regular:14.0",
    color         = colors.white,
    padding_left  = 8,
    padding_right = 4,
    drawing       = true,
  },
  label = {
    string        = "",
    font          = "SF Pro Text:Regular:13.0",
    color         = colors.white,
    padding_left  = 0,
    padding_right = 8,
  },
})

local function update_front_app(app_name)
  if not app_name or app_name == "" then return end
  -- Strip any double-quotes from app name to avoid shell injection in the exec call.
  local safe_name = app_name:gsub('"', "")
  sbar.exec('/bin/bash "' .. HELPERS .. '/icon_for_app.sh" "' .. safe_name .. '"', function(icon)
    front_app:set({
      icon  = { string = (icon or ""):match("^(.-)%s*$") or "" },
      label = { string = app_name },
    })
  end)
end

front_app:subscribe("front_app_switched", function(env)
  update_front_app(env.INFO)
end)

-- Set initial front app synchronously before the event loop starts.
local handle = io.popen(
  "osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true' 2>/dev/null"
)
if handle then
  local app = (handle:read("*l") or ""):match("^(.-)%s*$") or ""
  handle:close()
  update_front_app(app)
end
