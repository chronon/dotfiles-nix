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
    "folke/edgy.nvim",
    opts = function(_, opts)
      opts.bottom = {}
      table.insert(opts.bottom, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { height = 30 },
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-sonnet-4",
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
      },
    },
  },

  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
    },
  },
}
