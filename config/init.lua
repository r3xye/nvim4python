-- Main Neovim configuration file
vim.g.mapleader = " "

-- Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 300

-- Load plugins via lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

-- Load configurations
require("config.lsp")
require("config.cmp")
require("config.telescope")
require("config.neotree")
require("config.lualine")
require("config.bufferline")
require("config.gitsigns")
require("config.dap")
require("config.comment")
require("config.autopairs")
require("config.indent")
require("config.alpha")
require("config.winshift")
require("config.whichkey")
require("config.surround")
require("config.themes")
require("config.terminal")
require("config.keymaps")
require("config.tests")
require("config.typst")
