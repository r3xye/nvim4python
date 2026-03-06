require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_hidden = false,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    mappings = {
      ["-"] = "navigate_up",
      ["<bs>"] = "navigate_up",
    },
  },
})

-- Keymaps for Neotree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })
