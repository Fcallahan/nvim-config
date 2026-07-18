-- Enhanced settings for vim-dadbod-ui query results (dbout buffers)
--
-- Performance note: mouse drag + visual mode + window scrolling is a heavy
-- redraw path in Neovim. Every pixel scrolled triggers a full redraw of the
-- visible area, including syntax highlighting, cursorline, and folds.
-- Dbout result buffers can have thousands of rows and very wide columns
-- (10+ columns of data), which makes this path even slower.

--
-- Buffer-local display settings.
--

vim.opt_local.wrap = false              -- Don't wrap long lines
vim.opt_local.cursorline = false        -- Disabled: cursorline forces a full-line highlight
                                        -- recompute on EVERY redraw. During visual mode
                                        -- mouse drag + scroll, this adds massive overhead
                                        -- for very wide result rows.
vim.opt_local.cursorcolumn = false
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.list = false

-- scrolloff=0: with any scrolloff > 0, Neovim starts scrolling BEFORE the
-- cursor hits the window edge, generating MORE scroll redraws during mouse
-- drags. Since dbout is a read-only result buffer, scrolloff has no usability
-- benefit -- it only multiplies the redraw cost.
vim.opt_local.scrolloff = 0
vim.opt_local.sidescrolloff = 0

--
-- Folding: completely disabled.
--
-- DBUI's ftplugin sets foldmethod=expr with a custom foldexpr that runs regex
-- on adjacent lines. Even with foldenable=0, Neovim still computes fold levels
-- (it just doesn't display them). foldmethod=manual kills ALL fold computation.
vim.opt_local.foldenable = false
vim.opt_local.foldmethod = "manual"

--
-- Keymaps (normal mode only -- irrelevant for mouse issues but kept for usability).
--

local opts = { buffer = true, silent = true, noremap = true }

vim.keymap.set("n", "<Tab>", "W", opts)      -- Next column
vim.keymap.set("n", "<S-Tab>", "B", opts)    -- Previous column
vim.keymap.set("n", "<C-d>", "10j", opts)    -- Scroll down 10 rows
vim.keymap.set("n", "<C-u>", "10k", opts)    -- Scroll up 10 rows
vim.keymap.set("n", "yc", "yic", opts)       -- Yank cell (same as yic)
vim.keymap.set("n", "vc", "vic", opts)       -- Visual select cell (same as vic)
vim.keymap.set("n", "yr", "yy", opts)        -- Yank current row

--
-- Syntax highlighting: added via vim.schedule to run after DBUI's syntax.
--
-- No containedin=ALL (flat buffer, no nested regions -- ALL is pure overhead).
-- No matchadd for individual border chars (| + - appear thousands of times in
-- tabular results and get re-evaluated on every redraw).

vim.schedule(function()
    -- Match NULL values (targeted, single-match per occurrence)
    vim.fn.matchadd("Comment", "\\<NULL\\>")

    -- Match header row (first few lines typically)
    vim.fn.matchadd("Title", "\\%^.*\\%<5l", 10)

    -- Simple pattern-based highlighting for common data types
    vim.cmd([[syntax match dboutNumber '\v<-?\d+\.?\d*>']])
    vim.api.nvim_set_hl(0, "dboutNumber", { fg = "#fab387" })  -- Orange

    vim.cmd([[syntax match dboutBoolean '\v<(true|false|TRUE|FALSE)>']])
    vim.api.nvim_set_hl(0, "dboutBoolean", { fg = "#a6e3a1" })  -- Green

    vim.cmd([[syntax match dboutNull '\v<NULL>']])
    vim.api.nvim_set_hl(0, "dboutNull", { fg = "#6c7086", italic = true })  -- Gray italic

    vim.cmd([[syntax match dboutDate '\v\d{4}-\d{2}-\d{2}']])
    vim.cmd([[syntax match dboutTime '\v\d{2}:\d{2}:\d{2}']])
    vim.api.nvim_set_hl(0, "dboutDate", { fg = "#89dceb" })  -- Cyan
    vim.api.nvim_set_hl(0, "dboutTime", { fg = "#89dceb" })  -- Cyan

    vim.cmd([[syntax match dboutInfo '\v\(\d+ rows?\)']])
    vim.api.nvim_set_hl(0, "dboutInfo", { fg = "#cba6f7", italic = true })  -- Purple

    -- Table borders get a subtle gray -- uses Comment highlight group
    vim.api.nvim_set_hl(0, "Comment", { fg = "#45475a" })

    -- Header row gets emphasized
    vim.api.nvim_set_hl(0, "Title", { fg = "#cdd6f4", bold = true })
end)
