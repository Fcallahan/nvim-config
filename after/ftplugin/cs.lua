-- Roslyn LSP will auto-start via roslyn.nvim plugin
-- No need for manual attachment since roslyn.nvim handles it

-- Set C# specific options
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.commentstring = '// %s'

-- Enable inlay hints for C# files
vim.lsp.inlay_hint.enable(true, { bufnr = 0 })