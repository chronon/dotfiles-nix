local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
  leader = {
    key = "a",
    mods = "CTRL",
    timeout_milliseconds = 1000,
  },
  keys = {
    {
      key = "LeftArrow",
      mods = "CTRL|SHIFT",
      action = act.ActivateTabRelative(-1),
    },
    {
      key = "RightArrow",
      mods = "CTRL|SHIFT",
      action = act.ActivateTabRelative(1),
    },
    {
      key = "-",
      mods = "LEADER",
      action = act.SplitPane({
        direction = "Down",
        size = { Percent = 25 },
      }),
    },
    {
      key = "\\",
      mods = "LEADER",
      action = act.SplitHorizontal({
        domain = "CurrentPaneDomain",
      }),
    },
  },
}

return keys
