-- List of available themes
local themes = {
  "catppuccin-mocha",
  "tokyonight",
  "gruvbox",
  "onedark",
  "nightfox",
  "kanagawa",
  "dracula",
  "everforest",
  "ayu-dark",
  "material",
  "github_dark",
  "nord",
  "rose-pine",
  "sonokai",
}

local current_theme_index = 1

-- Function to cycle themes
function CycleTheme()
  current_theme_index = current_theme_index % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  print("Theme: " .. themes[current_theme_index])
end

-- Keymap to cycle themes
vim.keymap.set("n", "<leader>tt", CycleTheme, { desc = "Cycle themes" })

-- Set initial theme
vim.cmd.colorscheme(themes[current_theme_index])