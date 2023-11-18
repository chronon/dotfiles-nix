local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  pane:split({
    size = 0.4,
    direction = "Bottom",
  })
  window:spawn_tab({})
end)
