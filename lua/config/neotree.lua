require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = true,
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    mappings = {
      ["<leader>o"] = "open",
      ["<leader>c"] = "close_node",
    },
  },
})

-- Keymaps for Neotree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })
vim.keymap.set("n", "<leader>nf", "<cmd>Neotree focus<cr>", { desc = "Focus Neotree" })
vim.keymap.set("n", "<leader>nr", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file in Neotree" })