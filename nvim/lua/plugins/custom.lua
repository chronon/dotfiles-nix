local colorscheme = os.getenv("COLORSCHEME_NVIM") or "catppuccin"

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

  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        --   auto_trigger = true,
        keymap = {
          accept = "<C-CR>",
          accept_word = "<C-W>",
          accept_line = "<C-L>",
        },
        -- filetypes = {
        --   text = false,
        -- },
      },
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
      opts.right = {}
      table.insert(opts.right, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { width = 65 },
      })
    end,
  },
}
