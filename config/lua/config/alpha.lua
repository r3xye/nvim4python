local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

vim.api.nvim_create_user_command("DashboardNewFile", function()
  local file_types = {
    { key = "1", label = "Python (.py)", ext = "py" },
    { key = "2", label = "C++ (.cpp)", ext = "cpp" },
    { key = "3", label = "Typst (.typ)", ext = "typ" },
  }

  local function create_file(ext)
    local function make_unique_name(extension)
      local stamp = os.date("%Y%m%d-%H%M%S")
      return string.format("untitled-%s.%s", stamp, extension)
    end

    local filetypes = {
      py = "python",
      cpp = "cpp",
      typ = "typst",
    }
    local templates = {
      cpp = {
        "#include <iostream>",
        "",
        "using namespace std;",
        "",
        "int main() {",
        "",
        "  return 0;",
        "}",
      },
      py = {
        "# Welcome, Pupamupa-enjoyer!",
        "",
        "",
        'if __name__ == "__main__":',
        '    print("Hello, Pupamupa!")',
      },
      typ = {
        "#set page(margin: 1cm,)",
        "",
        "#set text(size: 14pt)",
      },
    }

    vim.cmd("enew")
    local new_name = make_unique_name(ext)
    local ok, err = pcall(vim.cmd, "file " .. vim.fn.fnameescape(new_name))
    if not ok then
      vim.notify(
        "Could not assign file name " .. new_name .. ": " .. tostring(err),
        vim.log.levels.WARN
      )
    end
    vim.bo.filetype = filetypes[ext] or ""
    local content = templates[ext]
    if content then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
      vim.api.nvim_win_set_cursor(0, { #content, 0 })
    end
  end

  local lines = { "Create new file" }
  for _, item in ipairs(file_types) do
    table.insert(lines, string.format("%s. %s", item.key, item.label))
  end
  table.insert(lines, "q. Cancel")

  local width = 30
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  })

  local close_picker = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  for _, item in ipairs(file_types) do
    vim.keymap.set("n", item.key, function()
      close_picker()
      create_file(item.ext)
    end, { buffer = buf, nowait = true, silent = true })
  end

  vim.keymap.set("n", "q", close_picker, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", close_picker, { buffer = buf, nowait = true, silent = true })
end, {})

dashboard.section.header.val = {
  " ██████╗ ██╗   ██╗██████╗  █████╗ ███╗   ███╗██╗   ██╗██████╗  █████╗ ",
  " ██╔══██╗██║   ██║██╔══██╗██╔══██╗████╗ ████║██║   ██║██╔══██╗██╔══██╗",
  " ██████╔╝██║   ██║██████╔╝███████║██╔████╔██║██║   ██║██████╔╝███████║",
  " ██╔═══╝ ██║   ██║██╔═══╝ ██╔══██║██║╚██╔╝██║██║   ██║██╔═══╝ ██╔══██║",
  " ██║     ╚██████╔╝██║     ██║  ██║██║ ╚═╝ ██║╚██████╔╝██║     ██║  ██║",
  " ╚═╝      ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝",
  "",
}

dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", ":DashboardNewFile <CR>"),
  dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
  dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("s", "  Settings", ":e $MYVIMRC <CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}
dashboard.section.footer.val = ""

alpha.setup(dashboard.opts)
