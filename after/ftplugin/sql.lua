-- SQL-specific settings for dadbod completion
-- File: ~/.config/nvim/after/ftplugin/sql.lua

-- Optional: Auto-refresh cache when opening SQL files
-- Uncomment if you want automatic cache refresh (may cause slight delay with large schemas)
-- vim.api.nvim_create_autocmd("BufEnter", {
--     buffer = 0,
--     callback = function()
--         if vim.b.db or vim.g.db or vim.fn.exists('w:db') == 1 then
--             vim.cmd("DBCompletionClearCache")
--         end
--     end,
--     desc = "Auto-refresh DB cache on SQL file open"
-- })


-- SQL-specific keybindings (buffer-local)
vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", {
    buffer = true,
    desc = "Toggle DBUI"
})

vim.keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", {
    buffer = true,
    desc = "Find DB buffer"
})

vim.keymap.set("n", "<leader>dr", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf.execute_command({
        command = "postgres-lsp/refreshSchema",
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    })
    vim.notify("postgres-lsp schema refresh requested", vim.log.levels.INFO)
end, {
    buffer = true,
    desc = "Refresh postgres-lsp schema"
})

-- Execute SQL under cursor/visual selection
vim.keymap.set("v", "<leader>de", ":DB<CR>", {
    buffer = true,
    desc = "Execute SQL selection"
})

-- Execute entire buffer
vim.keymap.set("n", "<leader>dE", ":%DB<CR>", {
    buffer = true,
    desc = "Execute entire SQL buffer"
})
