local M = {}

local htop_state = {
  buf = nil,
  win = nil,
}

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function close_htop()
  if is_valid_win(htop_state.win) then
    vim.api.nvim_win_close(htop_state.win, true)
  end
  htop_state.win = nil
end

local function apply_terminal_style(buf, win)
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype = "htop"

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = false
  vim.wo[win].winfixbuf = true
  vim.wo[win].winblend = 6
  vim.wo[win].spell = false

  vim.api.nvim_set_hl(0, "HtopFloat", { link = "NormalFloat" })
  vim.api.nvim_set_hl(0, "HtopBorder", { link = "FloatBorder" })
  vim.api.nvim_set_hl(0, "HtopTitle", { link = "Title" })

  vim.api.nvim_set_option_value("winhighlight", table.concat({
    "Normal:HtopFloat",
    "FloatBorder:HtopBorder",
    "FloatTitle:HtopTitle",
  }, ","), { scope = "local", win = win })
end

local function open_htop_window()
  local width = math.max(90, math.floor(vim.o.columns * 0.72))
  local height = math.max(24, math.floor(vim.o.lines * 0.68))
  local row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1)
  local col = math.max(0, math.floor((vim.o.columns - width) / 2))

  local buf = htop_state.buf
  if not is_valid_buf(buf) then
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " htop ",
    title_pos = "center",
  })

  htop_state.buf = buf
  htop_state.win = win
  apply_terminal_style(buf, win)
  return buf, win
end

function M.toggle_htop()
  if is_valid_win(htop_state.win) then
    close_htop()
    return
  end

  if vim.fn.executable("htop") ~= 1 then
    vim.notify("htop not found in PATH", vim.log.levels.ERROR)
    return
  end

  local buf, _ = open_htop_window()
  if vim.bo[buf].buftype ~= "terminal" then
    vim.fn.termopen("htop", {
      on_exit = function()
        vim.schedule(function()
          if is_valid_buf(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
          htop_state.buf = nil
          htop_state.win = nil
        end)
      end,
    })

    vim.keymap.set("t", "q", close_htop, { buffer = buf, silent = true, nowait = true })
  end

  vim.cmd.startinsert()
end

function M.setup()
  vim.api.nvim_create_user_command("Htop", M.toggle_htop, { desc = "Toggle floating htop" })

  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(args)
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf })
    end,
  })

  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if not is_valid_win(htop_state.win) then
        return
      end

      close_htop()
      M.toggle_htop()
    end,
  })
end

return M
