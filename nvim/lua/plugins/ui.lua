return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = { "filename", path = 1 }
      table.insert(opts.sections.lualine_y, function()
        local mode = vim.api.nvim_get_mode()
        if mode.mode == "n" then
          local line_num = vim.fn.search([[\s\+$]], "nwc")
          return line_num ~= 0 and "⚠️ " .. line_num or ""
        else
          return ""
        end
      end)
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = false,
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          -- Disable "No information available" when multiple LSP servers are running
          silent = true,
        },
      },
    },
  },
}
