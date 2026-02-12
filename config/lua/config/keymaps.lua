-- Custom keymaps
local typst = require("config.typst")
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

local function run_in_terminal(cmd, desc)
  if vim.fn.executable("kitty") ~= 1 then
    vim.notify("kitty not found in PATH", vim.log.levels.ERROR)
    return
  end

  local cwd = vim.fn.getcwd()
  local job_id = vim.fn.jobstart({ "kitty", "--working-directory", cwd, "--hold", "sh", "-lc", cmd }, { detach = true })
  if job_id > 0 then
    vim.g.last_run_job_id = job_id
    vim.g.last_run_desc = desc or cmd
  end
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

  local rel_escaped = vim.fn.shellescape(rel)
  local cmd = python .. " " .. rel_escaped
  run_in_terminal(cmd, cmd)
end

local function run_cpp_in_terminal()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end
  if not file:match("%.c$") and not file:match("%.cc$") and not file:match("%.cpp$") and not file:match("%.cxx$") then
    vim.notify("Not a C/C++ file", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("g++") ~= 1 then
    vim.notify("g++ not found in PATH", vim.log.levels.ERROR)
    return
  end

  local rel = vim.fn.fnamemodify(file, ":.")
  if rel:sub(1, 2) == ".." then
    vim.notify("File is outside current working directory", vim.log.levels.ERROR)
    return
  end

  local out_dir = "compile"
  local out = vim.fn.fnamemodify(file, ":t:r")
  local out_path = out_dir .. "/" .. out
  local rel_escaped = vim.fn.shellescape(rel)
  local out_dir_escaped = vim.fn.shellescape(out_dir)
  local out_path_escaped = vim.fn.shellescape(out_path)
  local cmd = string.format(
    "mkdir -p %s && g++ -std=c++20 -O0 -g %s -o %s && %s",
    out_dir_escaped,
    rel_escaped,
    out_path_escaped,
    out_path_escaped
  )
  run_in_terminal(cmd, cmd)
end

local function run_current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end

  if file:match("%.py$") then
    run_python_module_in_terminal()
    return
  end

  if file:match("%.typ$") or file:match("%.typst$") then
    typst.toggle_watch()
    return
  end

  if file:match("%.c$") or file:match("%.cc$") or file:match("%.cpp$") or file:match("%.cxx$") then
    run_cpp_in_terminal()
    return
  end

  vim.notify("No runner for this file type", vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>fR", rename_current_file, { desc = "Rename file" })
vim.keymap.set("n", "<leader>r", run_current_file, { desc = "Run current file" })

local function stop_last_run()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" and (file:match("%.typ$") or file:match("%.typst$")) then
    typst.stop()
    vim.notify("Typst stopped", vim.log.levels.INFO)
    return
  end

  if vim.g.last_run_job_id and vim.fn.jobwait({ vim.g.last_run_job_id }, 0)[1] == -1 then
    vim.fn.jobstop(vim.g.last_run_job_id)
    local desc = vim.g.last_run_desc or "last job"
    vim.notify("Stopped: " .. desc, vim.log.levels.INFO)
    return
  end

  vim.notify("No running job to stop", vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>s", stop_last_run, { desc = "Stop current run" })
