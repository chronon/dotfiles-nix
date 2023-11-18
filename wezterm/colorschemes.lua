local colorscheme = "kanagawa"

local colorschemes = {
  kanagawa = {
    wezterm = "Kanagawa (Gogh)",
    fish = "kanagawa.fish",
    nvim = "kanagawa",
  },
  tokyonight = {
    wezterm = "Tokyo Night",
    fish = "tokyonight_night.fish",
    nvim = "tokyonight-night",
  },
}

return colorschemes[colorscheme]
