local colorscheme = os.getenv("COLORSCHEME_NVIM") or "catppuccin-mocha"

return {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme,
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
}
