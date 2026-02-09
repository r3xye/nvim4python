-- Pytest runner with quickfix output
local function run_pytest()
  if vim.fn.executable("pytest") ~= 1 then
    vim.notify("pytest not found in PATH", vim.log.levels.ERROR)
    return
  end
  local cmd = { "pytest", "--maxfail=1", "--disable-warnings", "--tb=short" }
  local output = vim.fn.systemlist(cmd)
  local exit_code = vim.v.shell_error

  local old_efm = vim.o.errorformat
  vim.o.errorformat = "%E%f:%l: %m,%Z%p^,%C%.%#"
  vim.fn.setqflist({}, " ", { title = "pytest", lines = output })
  vim.o.errorformat = old_efm

  if exit_code == 0 then
    vim.notify("Pytest: OK", vim.log.levels.INFO)
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

vim.keymap.set("n", "<leader>rt", run_pytest, { desc = "Run pytest" })
