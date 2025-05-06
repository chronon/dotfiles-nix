return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<C-p>", LazyVim.pick("auto"), desc = "Find Files (root dir)" },
    },
    opts = {
      picker = {
        formatters = {
          file = {
            filename_first = true,
            truncate = 500,
          },
        },
      },
    },
  },
}
