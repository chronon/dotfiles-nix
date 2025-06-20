local colorscheme = os.getenv("COLORSCHEME_NVIM") or "kanagawa"

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    name = "kanagawa",
    opts = {
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme,
    },
  },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       keymap = {
  --         accept = "<C-CR>",
  --         accept_word = "<C-W>",
  --         accept_line = "<C-L>",
  --       },
  --     },
  --     filetypes = {
  --       text = false,
  --       markdown = false,
  --     },
  --     copilot_model = "gpt-4o-copilot", -- or gpt-35-turbo
  --   },
  -- },

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

  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   opts = {
  --     model = "claude-3.7-sonnet",
  --   },
  -- },
}
