return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {},
        cssls = {},
        html = {},
        tsserver = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        tailwindcss = {
          -- autostart = false,
        },
      },
    },
  },

  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     -- opts.debug = true
  --     local nls = require("null-ls")
  --     table.insert(
  --       opts.sources,
  --       nls.builtins.diagnostics.phpcs.with({
  --         condition = function(utils)
  --           return utils.root_has_file({ "bin/phpcs" })
  --         end,
  --         prefer_local = "bin",
  --       })
  --     )
  --   end,
  -- },
}
