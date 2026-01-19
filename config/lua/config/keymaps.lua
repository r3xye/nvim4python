-- Custom keymaps
local function rename_current_file()
  local old_path = vim.api.nvim_buf_get_name(0)
  if old_path == "" then
    vim.notify("No file to rename", vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.fnamemodify(old_path, ":h")
  local old_name = vim.fn.fnamemodify(old_path, ":t")

  vim.ui.input({ prompt = "Rename to: ", default = old_name }, function(new_name)
    if not new_name or new_name == "" or new_name == old_name then
      return
    end

    local new_path = dir .. "/" .. new_name
    if vim.fn.filereadable(new_path) == 1 then
      vim.notify("Target exists: " .. new_path, vim.log.levels.ERROR)
      return
    end

    local ok = vim.fn.rename(old_path, new_path)
    if ok ~= 0 then
      vim.notify("Rename failed", vim.log.levels.ERROR)
      return
    end

    vim.cmd("edit " .. vim.fn.fnameescape(new_path))
    vim.cmd("bdelete " .. vim.fn.bufnr(old_path))
  end)
end

local function create_project_venv()
  local venv_path = ".venv"
  if vim.fn.isdirectory(venv_path) == 1 then
    vim.notify("Venv already exists: " .. venv_path, vim.log.levels.INFO)
    return
  end

  local python = nil
  if vim.fn.executable("python") == 1 then
    python = "python"
  elseif vim.fn.executable("python3") == 1 then
    python = "python3"
  end

  if not python then
    vim.notify("Python not found in PATH", vim.log.levels.ERROR)
    return
  end

  vim.notify("Creating venv in " .. venv_path .. "...", vim.log.levels.INFO)
  local output = vim.fn.system({ python, "-m", "venv", venv_path })
  if vim.v.shell_error ~= 0 then
    vim.notify("Venv creation failed: " .. output, vim.log.levels.ERROR)
    return
  end

  vim.notify("Venv created: " .. venv_path, vim.log.levels.INFO)
end

local function run_python_module_in_terminal()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end
  if not file:match("%.py$") then
    vim.notify("Not a Python file", vim.log.levels.WARN)
    return
  end

  local rel = vim.fn.fnamemodify(file, ":.")
  if rel:sub(1, 2) == ".." then
    vim.notify("File is outside current working directory", vim.log.levels.ERROR)
    return
  end

  local module = rel:gsub("%.py$", ""):gsub("/", ".")

  vim.cmd("botright split")
  vim.cmd("terminal")
  vim.cmd("startinsert")

  local chan = vim.b.terminal_job_id
  if not chan then
    vim.notify("Terminal not ready", vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_chan_send(chan, "python -m " .. module .. "\n")
end

vim.keymap.set("n", "<leader>fr", rename_current_file, { desc = "Rename file" })
vim.keymap.set("n", "<leader>pv", create_project_venv, { desc = "Python venv" })
vim.keymap.set("n", "<leader>pr", run_python_module_in_terminal, { desc = "Python run module" })
