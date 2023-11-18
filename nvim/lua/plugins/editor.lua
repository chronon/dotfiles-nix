return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "composer.lock",
          "package-lock.json",
          "yarn.lock",
        },
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("telescope.actions").select_tab(...)
            end,
          },
        },
      },
    },
    keys = {
      { "<C-p>", require("lazyvim.util").telescope("files"), desc = "Find Files (root dir)" },
    },
  },

  {
    "RRethy/vim-illuminate",
    opts = {
      filetypes_denylist = {
        "gitcommit",
      },
      min_count_to_highlight = 2,
    },
  },
}
