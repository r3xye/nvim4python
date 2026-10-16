local dap = require("dap")
local dap_python = require("dap-python")
local python = require("config.python")

dap_python.setup(python.get_system_python() or "python")
dap_python.resolve_python = function()
  return python.get_python({ root = python.get_project_root(0) }) or "python"
end

-- DAP UI
local ok_ui, dapui = pcall(require, "dap-ui")
if ok_ui then
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    layouts = {
      {
        elements = {
          { id = "scopes",      size = 0.35 },
          { id = "breakpoints", size = 0.20 },
          { id = "stacks",      size = 0.25 },
          { id = "watches",     size = 0.20 },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          { id = "repl",    size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 10,
      },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"]    = function() dapui.close() end

  vim.keymap.set("n", "<leader>dU", function() dapui.toggle() end, { desc = "Debug toggle UI" })
end

-- Resolve LLDB adapter (supports C/C++/Rust/Zig)
local function resolve_lldb_adapter()
  -- Prefer codelldb from mason
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
  if vim.fn.executable(mason_bin) == 1 then
    return {
      type = "server",
      port = "${port}",
      executable = { command = mason_bin, args = { "--port", "${port}" } },
    }
  end

  -- Fallback: codelldb in PATH
  local codelldb = vim.fn.exepath("codelldb")
  if codelldb ~= "" then
    return {
      type = "server",
      port = "${port}",
      executable = { command = codelldb, args = { "--port", "${port}" } },
    }
  end

  -- Fallback: lldb-vscode / lldb-dap in PATH
  for _, bin in ipairs({ "lldb-dap", "lldb-vscode" }) do
    local p = vim.fn.exepath(bin)
    if p ~= "" then
      return { type = "executable", command = p, name = "lldb" }
    end
  end

  return nil
end

local lldb_adapter = resolve_lldb_adapter()

-- ── C / C++ ──────────────────────────────────────────────────────────────────
if lldb_adapter then
  dap.adapters.cpp   = lldb_adapter
  dap.adapters.c     = lldb_adapter
  dap.adapters.codelldb = lldb_adapter

  local native_launch = {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  }

  dap.configurations.cpp = { native_launch }
  dap.configurations.c   = { native_launch }
end

-- ── Rust ─────────────────────────────────────────────────────────────────────
if lldb_adapter then
  dap.adapters.rust = lldb_adapter

  dap.configurations.rust = {
    {
      name = "Launch binary",
      type = "codelldb",
      request = "launch",
      -- Auto-detect Cargo binary for the current workspace
      program = function()
        local cargo_meta = vim.fn.system("cargo metadata --no-deps --format-version 1 2>/dev/null")
        local ok, meta = pcall(vim.fn.json_decode, cargo_meta)
        if ok and meta and meta.packages and meta.packages[1] then
          local pkg = meta.packages[1]
          local target_dir = meta.target_directory
          -- Look for a binary target with the same name as the package
          for _, target in ipairs(pkg.targets) do
            for _, kind in ipairs(target.kind) do
              if kind == "bin" then
                local candidate = target_dir .. "/debug/" .. target.name
                if vim.fn.filereadable(candidate) == 1 then
                  return candidate
                end
              end
            end
          end
        end
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
    {
      name = "Launch binary (prompt)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
  }
end

-- ── Zig ──────────────────────────────────────────────────────────────────────
if lldb_adapter then
  dap.adapters.zig = lldb_adapter

  dap.configurations.zig = {
    {
      name = "Launch binary",
      type = "codelldb",
      request = "launch",
      -- Zig puts debug binaries in zig-out/bin/<name>
      program = function()
        local cwd = vim.fn.getcwd()
        local bin_dir = cwd .. "/zig-out/bin"
        if vim.fn.isdirectory(bin_dir) == 1 then
          return vim.fn.input("Path to executable: ", bin_dir .. "/", "file")
        end
        return vim.fn.input("Path to executable: ", cwd .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
  }
end

-- ── Keymaps ───────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "Debug continue" })
vim.keymap.set("n", "<leader>do", dap.step_over,         { desc = "Debug step over" })
vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "Debug step into" })
vim.keymap.set("n", "<leader>du", dap.step_out,          { desc = "Debug step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug conditional breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open,  { desc = "Debug REPL" })
vim.keymap.set("n", "<leader>dl", dap.run_last,   { desc = "Debug run last" })
