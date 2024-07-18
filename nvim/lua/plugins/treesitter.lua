return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "fish",
        "html",
        "markdown",
        "markdown_inline",
        "php",
        "phpdoc",
        "query",
        "regex",
        "scss",
        "sql",
        "xml",
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
