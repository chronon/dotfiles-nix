return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {},
        marksman = { enabled = false },
        cssls = {
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
      inlay_hints = { enabled = false },
    },
  },
}
