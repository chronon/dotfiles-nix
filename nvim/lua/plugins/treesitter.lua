return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "fish",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "php",
        "phpdoc",
        "query",
        "regex",
        "scss",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        disable = {
          "yaml",
        },
      },
      indent = {
        disable = {
          "yaml",
        },
      },
    },
  },
}
