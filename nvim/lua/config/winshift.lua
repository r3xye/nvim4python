require("winshift").setup()

-- Keymaps for winshift
vim.keymap.set("n", "<C-W><C-M>", "<cmd>WinShift<cr>", { desc = "WinShift" })
vim.keymap.set("n", "<C-W>m", "<cmd>WinShift<cr>", { desc = "WinShift" })