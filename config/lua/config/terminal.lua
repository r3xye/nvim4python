vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("t", "<Esc>", [[<C-\\><C-n>]], { buffer = true })
  end,
})
