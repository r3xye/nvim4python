require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "lua_ls", "ruff", "tinymist" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Python LSP
vim.lsp.config("pyright", {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "openFilesOnly",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportMissingImports = "none",
          reportMissingTypeStubs = "none",
        },
      },
      completion = {
        completeFunctionParens = true,
      },
    },
  },
})

-- Lua LSP
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

-- Ruff LSP (Python linting/formatting)
vim.lsp.config("ruff", {
  capabilities = capabilities,
})

-- Typst LSP (Tinymist)
vim.lsp.config("tinymist", {
  capabilities = capabilities,
})

vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ruff")
vim.lsp.enable("tinymist")

-- Keymaps for LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, { desc = "Format" })

-- IDE-like hover on cursor hold
local hover_group = vim.api.nvim_create_augroup("LspHover", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = hover_group,
  callback = function()
    if vim.fn.mode() ~= "n" then
      return
    end
    if vim.fn.pumvisible() == 1 then
      return
    end
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return
    end
    vim.lsp.buf.hover()
  end,
})
