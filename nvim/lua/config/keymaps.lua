vim.keymap.set("n", "<leader>hh", "<cmd>nohl<cr>", { desc = "No highlight" })
vim.keymap.set("n", "<leader>rn", "<cmd>set invrelativenumber<cr>", { desc = "Toggle relative line number" })
vim.keymap.set(
  "n",
  "<leader>ac",
  "<cmd>!docker-compose exec -T php bin/convert.php -w ../%<cr>",
  { desc = "Convert PHP arrays" }
)

vim.keymap.set("x", "<leader>cx", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("x", "p", '"_dP', { desc = "Black hole register" })
vim.keymap.set("x", "<LeftRelease>", '"+ygv', { desc = "Copy to clipboard" })

vim.api.nvim_create_user_command("PhpStan", "! bin/phpstan analyse %", {})
vim.api.nvim_create_user_command("AnsibleFile", "setlocal ft=yaml.ansible", {})
