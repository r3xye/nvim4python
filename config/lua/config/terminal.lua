-- Built-in terminal helpers
local function open_terminal_split()
  vim.cmd("botright split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>ot", open_terminal_split, { desc = "Open terminal" })

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("t", "<Esc>", [[<C-\\><C-n>]], { buffer = true })
  end,
})
