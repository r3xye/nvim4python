local function current_theme()
  return "theme:" .. (vim.g.colors_name or "none")
end

local function full_filepath()
  local path = vim.fn.expand("%:p")
  if path == "" then
    return "[No Name]"
  end
  return path
end

local function active_cwd()
  return "cwd:" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

require("lualine").setup({
  options = {
    globalstatus = true,
    theme = "catppuccin",
    component_separators = "|",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { full_filepath } },
    lualine_x = {
      { active_cwd, icon = "" },
      { current_theme },
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
