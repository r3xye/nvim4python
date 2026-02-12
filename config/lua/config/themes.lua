-- List of available themes
local themes = {
  "catppuccin-mocha",
  "hello-kitty-pink",
  "barbie-candy-pink",
  "pickme-pink",
  "tokyonight",
  "gruvbox",
  "onedark",
  "nightfox",
  "kanagawa",
  "dracula",
  "everforest",
  "gruvbox-material",
  "ayu-dark",
  "material",
  "github_dark",
  "nord",
  "rose-pine",
  "sonokai",
  "nightfly",
}

local theme_state_file = vim.fn.stdpath("state") .. "/theme.txt"
local current_theme_index = 1

local function apply_barbie_candy_pink()
  local ok = pcall(vim.cmd.colorscheme, "rose-pine")
  if not ok then
    return false
  end

  local hl = vim.api.nvim_set_hl
  hl(0, "Normal", { fg = "#fff2fb", bg = "#3b0f2a" })
  hl(0, "NormalFloat", { fg = "#fff2fb", bg = "#4b1435" })
  hl(0, "FloatBorder", { fg = "#ff7ecf", bg = "#4b1435" })
  hl(0, "CursorLine", { bg = "#5d1942" })
  hl(0, "CursorColumn", { bg = "#5d1942" })
  hl(0, "Visual", { bg = "#8a2a63" })
  hl(0, "LineNr", { fg = "#f08ac4" })
  hl(0, "CursorLineNr", { fg = "#ff3fa8", bold = true })
  hl(0, "Comment", { fg = "#e6a3cb", italic = true })
  hl(0, "Identifier", { fg = "#ff8fd6" })
  hl(0, "Function", { fg = "#ff3fa8", bold = true })
  hl(0, "Type", { fg = "#ffd8f0", bold = true })
  hl(0, "Keyword", { fg = "#ff63be", italic = true })
  hl(0, "String", { fg = "#ffb7e4" })
  hl(0, "Constant", { fg = "#ff8fd6" })
  hl(0, "Statement", { fg = "#ff63be", bold = true })
  hl(0, "PreProc", { fg = "#ffb7e4" })
  hl(0, "Pmenu", { fg = "#fff2fb", bg = "#5d1942" })
  hl(0, "PmenuSel", { fg = "#3b0f2a", bg = "#ff9ddd", bold = true })
  hl(0, "StatusLine", { fg = "#fff2fb", bg = "#6b1d4b", bold = true })
  hl(0, "StatusLineNC", { fg = "#e2a8cc", bg = "#4b1435" })
  hl(0, "WinSeparator", { fg = "#ff9ddd" })
  hl(0, "Search", { fg = "#3b0f2a", bg = "#ffc6ea", bold = true })
  hl(0, "IncSearch", { fg = "#fff2fb", bg = "#ff2f9e", bold = true })

  return true
end

local function apply_hello_kitty_pink()
  local ok = pcall(vim.cmd.colorscheme, "rose-pine")
  if not ok then
    return false
  end

  local hl = vim.api.nvim_set_hl
  hl(0, "Normal", { fg = "#ffe9f7", bg = "#29081f" })
  hl(0, "NormalFloat", { fg = "#ffe9f7", bg = "#380b2a" })
  hl(0, "FloatBorder", { fg = "#ff52b2", bg = "#380b2a" })
  hl(0, "CursorLine", { bg = "#4f1038" })
  hl(0, "CursorColumn", { bg = "#4f1038" })
  hl(0, "Visual", { bg = "#7a1b58" })
  hl(0, "LineNr", { fg = "#de5da8" })
  hl(0, "CursorLineNr", { fg = "#ff2f9a", bold = true })
  hl(0, "Comment", { fg = "#e08abb", italic = true })
  hl(0, "Identifier", { fg = "#ff73c5" })
  hl(0, "Function", { fg = "#ff2f9a", bold = true })
  hl(0, "Type", { fg = "#ffd0ea", bold = true })
  hl(0, "Keyword", { fg = "#ff57b3", italic = true })
  hl(0, "String", { fg = "#ff9fd7" })
  hl(0, "Constant", { fg = "#ff73c5" })
  hl(0, "Statement", { fg = "#ff57b3", bold = true })
  hl(0, "PreProc", { fg = "#ff9fd7" })
  hl(0, "Pmenu", { fg = "#ffe9f7", bg = "#4f1038" })
  hl(0, "PmenuSel", { fg = "#29081f", bg = "#ff66bd", bold = true })
  hl(0, "StatusLine", { fg = "#ffe9f7", bg = "#5b1241", bold = true })
  hl(0, "StatusLineNC", { fg = "#dd8fba", bg = "#380b2a" })
  hl(0, "WinSeparator", { fg = "#ff66bd" })
  hl(0, "Search", { fg = "#29081f", bg = "#ffa8dc", bold = true })
  hl(0, "IncSearch", { fg = "#ffe9f7", bg = "#ff1493", bold = true })

  return true
end

local function apply_pickme_pink()
  local ok = pcall(vim.cmd.colorscheme, "rose-pine")
  if not ok then
    return false
  end

  local hl = vim.api.nvim_set_hl
  hl(0, "Normal", { fg = "#f8e1f4", bg = "#1a1120" })
  hl(0, "NormalFloat", { fg = "#f8e1f4", bg = "#24162c" })
  hl(0, "CursorLine", { bg = "#2d1c37" })
  hl(0, "Visual", { bg = "#4a2a56" })
  hl(0, "LineNr", { fg = "#9b6ea8" })
  hl(0, "CursorLineNr", { fg = "#ff7ab6", bold = true })
  hl(0, "Comment", { fg = "#b184c2", italic = true })
  hl(0, "Identifier", { fg = "#ff8cc8" })
  hl(0, "Function", { fg = "#ff6eb4", bold = true })
  hl(0, "Type", { fg = "#ffc1e3" })
  hl(0, "Keyword", { fg = "#ff7ac6", italic = true })
  hl(0, "String", { fg = "#f9b3d7" })
  hl(0, "Pmenu", { fg = "#f8e1f4", bg = "#2a1a33" })
  hl(0, "PmenuSel", { fg = "#1a1120", bg = "#ff8cc8", bold = true })
  hl(0, "StatusLine", { fg = "#f8e1f4", bg = "#2d1c37" })
  hl(0, "StatusLineNC", { fg = "#a684b4", bg = "#24162c" })
  hl(0, "FloatBorder", { fg = "#d59ad7", bg = "#24162c" })

  return true
end

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
  local ok
  if name == "barbie-candy-pink" then
    ok = apply_barbie_candy_pink()
  elseif name == "hello-kitty-pink" then
    ok = apply_hello_kitty_pink()
  elseif name == "pickme-pink" then
    ok = apply_pickme_pink()
  else
    ok = pcall(vim.cmd.colorscheme, name)
  end
  if ok then
    save_theme(name)
    return true
  end
  return false
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

-- Keymap to select theme
vim.keymap.set("n", "<leader>t", SelectTheme, { desc = "Theme select" })

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
