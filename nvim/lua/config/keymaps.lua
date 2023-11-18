local wk = require("which-key")

wk.register({
  h = {
    h = { "<cmd>nohl<cr>", "No highlight" },
  },
  r = {
    n = { "<cmd>set invrelativenumber<cr>", "Toggle relative line number" },
  },
  a = {
    c = { "<Cmd>!docker-compose exec -T php bin/convert.php -w ../%<CR>", "Convert PHP arrays" },
  },
  c = {
    c = { '"+y', "Copy to clipboard", mode = "x" },
  },
}, {
  prefix = "<leader>",
})

wk.register({
  p = { '"_dP', "Black hole register" },
  ["<LeftRelease>"] = { '"+ygv', "Copy to clipboard" },
}, {
  mode = "x",
})

vim.api.nvim_create_user_command("PhpStan", "! bin/phpstan analyse %", {})
vim.api.nvim_create_user_command("AnsibleFile", "setlocal ft=yaml.ansible", {})
