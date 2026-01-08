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

-- Function to select theme with Telescope
function SelectTheme()
  local telescope = require("telescope")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Select Theme",
    finder = finders.new_table({
      results = themes,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd.colorscheme(selection[1])
        print("Theme: " .. selection[1])
      end)
      return true
    end,
  }):find()
end

-- Keymap to cycle themes
vim.keymap.set("n", "<leader>tt", CycleTheme, { desc = "Cycle themes" })

-- Keymap to select theme
vim.keymap.set("n", "<leader>ts", SelectTheme, { desc = "Select theme" })

-- Set initial theme
vim.cmd.colorscheme(themes[current_theme_index])