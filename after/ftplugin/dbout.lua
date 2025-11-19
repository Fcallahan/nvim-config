-- Enhanced settings for vim-dadbod-ui query results (dbout buffers)
-- This file adds better readability and visual enhancements to query results

-- Buffer-local settings for better table readability
vim.opt_local.wrap = false              -- Don't wrap long lines
vim.opt_local.cursorline = true         -- Highlight current line
vim.opt_local.cursorcolumn = false      -- Don't highlight column (can be distracting)
vim.opt_local.number = false            -- Hide line numbers
vim.opt_local.relativenumber = false    -- Hide relative numbers
vim.opt_local.scrolloff = 3             -- Keep 3 lines visible above/below cursor
vim.opt_local.sidescrolloff = 5         -- Keep 5 columns visible left/right
vim.opt_local.list = false              -- Hide invisible characters

-- Better folding for large result sets
vim.opt_local.foldenable = false        -- Start with folds open
vim.opt_local.foldmethod = "indent"     -- Fold based on indentation

-- Keymaps for easier navigation in large result sets
local opts = { buffer = true, silent = true, noremap = true }

-- Jump between columns (use w/b for word-based navigation)
vim.keymap.set("n", "<Tab>", "W", opts)      -- Next column
vim.keymap.set("n", "<S-Tab>", "B", opts)    -- Previous column

-- Scroll result table more naturally
vim.keymap.set("n", "<C-d>", "10j", opts)    -- Scroll down 10 rows
vim.keymap.set("n", "<C-u>", "10k", opts)    -- Scroll up 10 rows

-- Quick access to column operations
vim.keymap.set("n", "yc", "yic", opts)       -- Yank cell (same as yic)
vim.keymap.set("n", "vc", "vic", opts)       -- Visual select cell (same as vic)

-- Copy entire row
vim.keymap.set("n", "yr", "yy", opts)        -- Yank current row

-- Use vim.schedule to ensure these run after plugin's syntax files
vim.schedule(function()
    -- Add syntax matching for better visual distinction
    -- Match table borders and separators
    vim.fn.matchadd("Comment", "[│┼├┤┬┴─┌┐└┘|+-]")

    -- Match NULL values
    vim.fn.matchadd("Comment", "\\<NULL\\>")

    -- Match header row (first few lines typically)
    vim.fn.matchadd("Title", "\\%^.*\\%<5l", 10)

    -- Simple pattern-based highlighting for common data types
    -- Numbers (integers and decimals)
    vim.cmd([[syntax match dboutNumber '\v<-?\d+\.?\d*>' containedin=ALL]])
    vim.api.nvim_set_hl(0, "dboutNumber", { fg = "#fab387" })  -- Orange

    -- Booleans
    vim.cmd([[syntax match dboutBoolean '\v<(true|false|TRUE|FALSE|t|f)>' containedin=ALL]])
    vim.api.nvim_set_hl(0, "dboutBoolean", { fg = "#a6e3a1" })  -- Green

    -- NULL values
    vim.cmd([[syntax match dboutNull '\v<NULL>' containedin=ALL]])
    vim.api.nvim_set_hl(0, "dboutNull", { fg = "#6c7086", italic = true })  -- Gray italic

    -- Timestamps/Dates (basic pattern)
    vim.cmd([[syntax match dboutDate '\v\d{4}-\d{2}-\d{2}' containedin=ALL]])
    vim.cmd([[syntax match dboutTime '\v\d{2}:\d{2}:\d{2}' containedin=ALL]])
    vim.api.nvim_set_hl(0, "dboutDate", { fg = "#89dceb" })  -- Cyan
    vim.api.nvim_set_hl(0, "dboutTime", { fg = "#89dceb" })  -- Cyan

    -- Row count indicator (bottom of results)
    vim.cmd([[syntax match dboutInfo '\v\(\d+ rows?\)' containedin=ALL]])
    vim.api.nvim_set_hl(0, "dboutInfo", { fg = "#cba6f7", italic = true })  -- Purple

    -- Table borders/separators get a subtle color
    vim.api.nvim_set_hl(0, "Comment", { fg = "#45475a" })  -- Subtle gray

    -- Header row gets emphasized
    vim.api.nvim_set_hl(0, "Title", { fg = "#cdd6f4", bold = true })  -- Bright white, bold
end)
