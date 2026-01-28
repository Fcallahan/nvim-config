-- Roslyn LSP will auto-start via roslyn.nvim plugin
-- No need for manual attachment since roslyn.nvim handles it

-- Set C# specific options
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.commentstring = '// %s'

-- Inlay hints disabled by default (can toggle with <leader>uh)
-- vim.lsp.inlay_hint.enable(true, { bufnr = 0 })