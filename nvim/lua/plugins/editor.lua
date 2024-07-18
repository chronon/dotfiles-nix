return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<C-p>", LazyVim.pick("auto"), desc = "Find Files (root dir)" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.triggers = { "<auto>", mode = "nisotc" }
    end,
  },
}
