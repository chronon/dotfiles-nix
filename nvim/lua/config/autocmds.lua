-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "php", "javascript" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "nix" },
  callback = function()
    vim.opt_local.commentstring = "# %s"
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
