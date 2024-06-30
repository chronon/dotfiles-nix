return {
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   opts = {
  --     defaults = {
  --       file_ignore_patterns = {
  --         "composer.lock",
  --         "package-lock.json",
  --         "pnpm-lock.yaml",
  --         "yarn.lock",
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<C-p>", LazyVim.pick("auto"), desc = "Find Files (root dir)" },
  --   },
  -- },

  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<C-p>", LazyVim.pick("auto"), desc = "Find Files (root dir)" },
    },
  },
}
