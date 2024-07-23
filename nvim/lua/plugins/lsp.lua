return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {},
        cssls = {
          autostart = false,
        },
        tailwindcss = {
          autostart = false,
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
