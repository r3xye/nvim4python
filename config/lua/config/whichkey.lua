require("which-key").setup({
  notify = false,
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = false,
      g = false,
    },
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  keys = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  win = {
    border = "rounded",
    padding = { 2, 2 },
    wo = {
      winblend = 0,
    },
  },
  layout = {
    width = { min = 20, max = 50 },
    spacing = 3,
  },
  show_help = true,
  triggers = {
    { "<auto>", mode = "nxso" },
  },
})

-- Register keymaps
local wk = require("which-key")
wk.register({
  ["<leader>b"] = { name = "Buffers" },
  ["<leader>d"] = { name = "Debug/Ruff" },
  ["<leader>e"] = { name = "Explorer" },
  ["<leader>f"] = { name = "Files/Find" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>h"] = { name = "Git Hunk" },
  ["<leader>l"] = { name = "LSP" },
  ["<leader>r"] = { name = "Run" },
  ["<leader>t"] = { name = "Theme" },
})
