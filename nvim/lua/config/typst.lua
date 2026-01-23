-- Typst helpers and keymaps
local function is_typst_path(path)
  return path:match("%.typ$") or path:match("%.typst$")
end

local function get_typst_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return nil
  end
  if not is_typst_path(file) then
    vim.notify("Not a Typst file", vim.log.levels.WARN)
    return nil
  end
  return file
end

local function get_pdf_path(typst_file)
  return vim.fn.fnamemodify(typst_file, ":r") .. ".pdf"
end

local function ensure_typst()
  if vim.fn.executable("typst") ~= 1 then
    vim.notify("typst not found in PATH", vim.log.levels.ERROR)
    return false
  end
  return true
end

local function compile_typst()
  if not ensure_typst() then
    return
  end

  local file = get_typst_file()
  if not file then
    return
  end

  local pdf = get_pdf_path(file)
  local output = vim.fn.system({ "typst", "compile", file, pdf })
  if vim.v.shell_error ~= 0 then
    vim.notify("Typst compile failed: " .. output, vim.log.levels.ERROR)
    return
  end

  vim.notify("Typst compiled: " .. pdf, vim.log.levels.INFO)
end

local function preview_typst()
  if not ensure_typst() then
    return
  end

  local file = get_typst_file()
  if not file then
    return
  end

  local pdf = get_pdf_path(file)
  local output = vim.fn.system({ "typst", "compile", file, pdf })
  if vim.v.shell_error ~= 0 then
    vim.notify("Typst compile failed: " .. output, vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable("zathura") ~= 1 then
    vim.notify("zathura not found in PATH", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({ "zathura", pdf }, { detach = true })
  vim.notify("Typst preview: " .. pdf, vim.log.levels.INFO)
end

local function watch_typst()
  if not ensure_typst() then
    return
  end

  local file = get_typst_file()
  if not file then
    return
  end

  if vim.g.typst_watch_job_id and vim.fn.jobwait({ vim.g.typst_watch_job_id }, 0)[1] == -1 then
    vim.notify("Typst watch already running", vim.log.levels.INFO)
    return
  end

  local cmd = { "typst", "watch", file }
  local job_id = vim.fn.jobstart(cmd, { detach = true })
  if job_id <= 0 then
    vim.notify("Failed to start typst watch", vim.log.levels.ERROR)
    return
  end

  vim.g.typst_watch_job_id = job_id
  if vim.fn.executable("zathura") == 1 then
    vim.fn.jobstart({ "zathura", get_pdf_path(file) }, { detach = true })
  else
    vim.notify("zathura not found in PATH", vim.log.levels.WARN)
  end
  vim.notify("Typst watch started (real-time preview)", vim.log.levels.INFO)
end

local function stop_watch_typst()
  if not vim.g.typst_watch_job_id then
    vim.notify("Typst watch not running", vim.log.levels.INFO)
    return
  end

  vim.fn.jobstop(vim.g.typst_watch_job_id)
  vim.g.typst_watch_job_id = nil
  vim.notify("Typst watch stopped", vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.typ", "*.typst" },
  callback = function()
    vim.bo.filetype = "typst"
  end,
})

local typst_autosave_timers = {}

local function schedule_typst_autosave(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
    return
  end
  if not is_typst_path(vim.api.nvim_buf_get_name(bufnr)) then
    return
  end

  if typst_autosave_timers[bufnr] then
    typst_autosave_timers[bufnr]:stop()
    typst_autosave_timers[bufnr]:close()
  end

  local timer = vim.loop.new_timer()
  typst_autosave_timers[bufnr] = timer
  timer:start(500, 0, function()
    timer:stop()
    timer:close()
    typst_autosave_timers[bufnr] = nil
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      if vim.bo[bufnr].modified then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("silent write")
        end)
      end
    end)
  end)
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
  pattern = { "*.typ", "*.typst" },
  callback = function(args)
    schedule_typst_autosave(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  pattern = { "*.typ", "*.typst" },
  callback = function(args)
    local timer = typst_autosave_timers[args.buf]
    if timer then
      timer:stop()
      timer:close()
      typst_autosave_timers[args.buf] = nil
    end
  end,
})

vim.keymap.set("n", "<leader>tc", compile_typst, { desc = "Typst compile" })
vim.keymap.set("n", "<leader>tv", preview_typst, { desc = "Typst preview" })
vim.keymap.set("n", "<leader>tw", watch_typst, { desc = "Typst watch" })
vim.keymap.set("n", "<leader>ts", stop_watch_typst, { desc = "Typst stop" })
