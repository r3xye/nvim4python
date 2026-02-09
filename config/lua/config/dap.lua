local dap = require("dap")
local dap_python = require("dap-python")

dap_python.setup("python")

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
