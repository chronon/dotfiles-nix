return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, function()
        local mode = vim.api.nvim_get_mode()
        if mode.mode == "n" then
          local line_num = vim.fn.search([[\s\+$]], "nwc")
          return line_num ~= 0 and " " .. line_num or ""
        else
          return ""
        end
      end)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.exclude.filetypes, {
        "php",
      })
    end,
  },

  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = "95%",
            col = "50%",
          },
        },
      },
    },
  },
}
