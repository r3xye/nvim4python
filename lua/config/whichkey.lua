require("which-key").setup({
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
  operators = { gc = "Comments" },
  key_labels = {},
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    border = "rounded",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  ignore_missing = true,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  show_help = true,
  triggers = "auto",
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
})

-- Register keymaps
local wk = require("which-key")
wk.register({
  ["<leader>b"] = { name = "Buffers" },
  ["<leader>c"] = { name = "Code/LSP" },
  ["<leader>d"] = { name = "Debug" },
  ["<leader>f"] = { name = "Find/Telescope" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>h"] = { name = "Git Hunk" },
  ["<leader>n"] = { name = "Neotree" },
  ["<leader>t"] = { name = "Toggle" },
  ["<leader>w"] = { name = "Window" },
})