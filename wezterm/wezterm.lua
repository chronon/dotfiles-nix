local wezterm = require("wezterm")
local act = wezterm.action
local home = os.getenv("HOME")
local mux = wezterm.mux

local config = {
  font_size = 16,
  default_prog = { home .. "/.nix-profile/bin/fish", "-l" },
  initial_rows = 100,
  initial_cols = 153,
  window_decorations = "RESIZE",
  force_reverse_video_cursor = true,

  color_scheme = "Kanagawa (Gogh)",
  set_environment_variables = {
    COLORSCHEME_FISH = "kanagawa.fish",
    COLORSCHEME_NVIM = "kanagawa",
  },

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
  mouse_bindings = {
    -- default click only selects text
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = act.CompleteSelection("ClipboardAndPrimarySelection"),
    },

    -- CTRL-click open hyperlinks
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = act.OpenLinkAtMouseCursor,
    },
  },
}

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  pane:split({
    size = 0.4,
    direction = "Bottom",
  })
  window:spawn_tab({})
end)

return config
