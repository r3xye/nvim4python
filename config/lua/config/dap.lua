local dap = require("dap")
local dap_python = require("dap-python")

dap_python.setup("python")

local function resolve_cpp_adapter()
  local codelldb = vim.fn.exepath("codelldb")
  if codelldb ~= "" then
    return {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb,
        args = { "--port", "${port}" },
      },
    }
  end

  local lldb_vscode = vim.fn.exepath("lldb-vscode")
  if lldb_vscode ~= "" then
    return {
      type = "executable",
      command = lldb_vscode,
      name = "lldb",
    }
  end

  return nil
end

local cpp_adapter = resolve_cpp_adapter()
if cpp_adapter then
  dap.adapters.cpp = cpp_adapter
  dap.adapters.c = cpp_adapter
  dap.adapters.rust = cpp_adapter

  local cpp_launch = {
    name = "Launch",
    type = "cpp",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  }

  dap.configurations.cpp = { cpp_launch }
  dap.configurations.c = { cpp_launch }
  dap.configurations.rust = { cpp_launch }
else
  vim.notify("C/C++ debugger not found (install codelldb or lldb-vscode)", vim.log.levels.WARN)
end

-- Keymaps for DAP
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug continue" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug step into" })
vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Debug step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug conditional breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug REPL" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug run last" })
