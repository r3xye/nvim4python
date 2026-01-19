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

local theme_state_file = vim.fn.stdpath("state") .. "/theme.txt"
local current_theme_index = 1

local function read_saved_theme()
  local f = io.open(theme_state_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  if name and name ~= "" then
    return name
  end
  return nil
end

local function save_theme(name)
  local f = io.open(theme_state_file, "w")
  if not f then
    return
  end
  f:write(name)
  f:close()
end

local function apply_theme(name)
  local ok = pcall(vim.cmd.colorscheme, name)
  if ok then
    save_theme(name)
    return true
  end
  return false
end

-- Function to cycle themes
function CycleTheme()
  current_theme_index = current_theme_index % #themes + 1
  local theme = themes[current_theme_index]
  if apply_theme(theme) then
    print("Theme: " .. theme)
  end
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
        if apply_theme(selection[1]) then
          print("Theme: " .. selection[1])
        end
      end)
      return true
    end,
  }):find()
end

-- Keymap to cycle themes
vim.keymap.set("n", "<leader>uc", CycleTheme, { desc = "Theme cycle" })

-- Keymap to select theme
vim.keymap.set("n", "<leader>us", SelectTheme, { desc = "Theme select" })

-- Set initial theme (restore saved theme if available)
local saved_theme = read_saved_theme()
if saved_theme then
  for i, name in ipairs(themes) do
    if name == saved_theme then
      current_theme_index = i
      break
    end
  end
  if not apply_theme(saved_theme) then
    apply_theme(themes[current_theme_index])
  end
else
  apply_theme(themes[current_theme_index])
end
