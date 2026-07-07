return {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },

  {
    "catppuccin/nvim",
    opts = {
      no_italic = true,
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      table.remove(opts.linters_by_ft.markdown)
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
      },
    },
  },

  -- {
  --   "folke/sidekick.nvim",
  --   opts = {
  --     nes = { enabled = false },
  --   },
  -- },
}
