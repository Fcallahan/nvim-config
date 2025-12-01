vim.g.mapleader = ' '
vim.keymap.set("n", "<leader>ntw", vim.cmd.Ex)

local opts = { noremap = true, silent = true }

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", opts)

vim.cmd("command W w")
vim.cmd("command Q q")
vim.cmd("command Qa qa")

-- Normal --
-- Better window navigation
--vim.api.nvim_set_keymap('n', "<C-d>", "<C-d>zz", opts)
--vim.api.nvim_set_keymap('n', "<C-u>", "<C-u>zz", opts)
vim.api.nvim_set_keymap('n', "<leader>v", ":vsplit<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>b", ":split<CR>", opts)

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Tabs
vim.api.nvim_set_keymap("n", "<leader>rk", ":resize +5<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rj", ":resize -5<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rh", ":vertical resize -5<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rl", ":vertical resize +5<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>tN", ":tabnew<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ts", ":tab split<CR>", opts)

vim.api.nvim_set_keymap("n", "gj", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "gk", ":bn<CR>", opts)

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Center buffer while navigating
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
-- Swap Ctrl+i and Ctrl+o: i=backwards, o=forwards (like you prefer)
vim.keymap.set("n", "<C-i>", "<C-o>zz", { desc = "Jump backwards (swapped)" })
vim.keymap.set("n", "<C-o>", "<C-i>zz", { desc = "Jump forwards (swapped)" })
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- greatest remap ever
vim.keymap.set({ "n", "v" }, "<leader>p", "\"0p")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Press '<leader>fr' for quick find/replace for the word under the cursor
vim.keymap.set("n", "<leader>fr", function()
    local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
    local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Goto next diagnostic of any severity
vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next({})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev({})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
vim.keymap.set("n", "]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
vim.keymap.set("n", "[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
vim.keymap.set("n", "]w", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
vim.keymap.set("n", "[w", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Place all dignostics into a qflist
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setqflist, { desc = "Quickfix [L]ist [D]iagnostics" })

-- Turn off highlighted results
vim.keymap.set("n", "<leader>no", "<cmd>noh<cr>")

-- LSP Navigation (similar to JetBrains/ideavimrc style)
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.lsp_definitions() end, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "<leader>gi", function() Snacks.picker.lsp_implementations() end, { desc = "[G]oto [I]mplementation" })
vim.keymap.set("n", "<leader>gD", function() vim.lsp.buf.declaration() end, { desc = "[G]oto [D]eclaration" })
vim.keymap.set("n", "<leader>gt", function() vim.lsp.buf.type_definition() end, { desc = "[G]oto [T]ype definition" })

vim.keymap.set("n", "<leader>oc", function()
    require("copilot.panel").open({})
end, { desc = "[O]pen [C]opilot panel" })

-- Terminal shortcuts (similar to your JetBrains setup)
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { desc = "[T]erminal [H]orizontal" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "[T]erminal [V]ertical" })
vim.keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>", { desc = "[T]erminal [T]ab" })

-- Terminal toggle function
local term_buf_id = nil
vim.keymap.set("n", "<C-t>", function()
    if term_buf_id and vim.api.nvim_buf_is_valid(term_buf_id) then
        local wins = vim.api.nvim_list_wins()
        for _, win in ipairs(wins) do
            if vim.api.nvim_win_get_buf(win) == term_buf_id then
                vim.api.nvim_win_close(win, false)
                return
            end
        end
        -- Terminal buffer exists but no window, reopen it
        vim.cmd("botright split")
        vim.api.nvim_win_set_buf(0, term_buf_id)
        vim.cmd("resize 15")
    else
        -- Create new terminal
        vim.cmd("botright split | resize 15 | terminal")
        term_buf_id = vim.api.nvim_get_current_buf()
    end
end, { desc = "Toggle terminal" })

-- Exit terminal mode easily
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Build shortcuts (similar to ideavimrc)
vim.keymap.set("n", "<leader>rs", "<cmd>!dotnet clean && dotnet restore<CR>", { desc = "[R]estore [S]olution" })
vim.keymap.set("n", "<leader>rb", "<cmd>!dotnet build<CR>", { desc = "[R]un [B]uild" })

-- Quick document creation (for your workflow)
vim.keymap.set("n", "<leader>nd", ":enew<CR>", { desc = "[N]ew [D]ocument" })
vim.keymap.set("n", "<leader>ns", ":enew | vsplit | terminal<CR>", { desc = "[N]ew doc + [S]hell side-by-side" })

-- Close split/buffer (similar to your ideavimrc <leader>x)
vim.keymap.set("n", "<leader>x", ":q<CR>", { desc = "Close split/window" })

-- Create TODO command to open daily notes in a float window
vim.api.nvim_create_user_command("TODO", function()
    -- Expand the home directory path
    local file_path = vim.fn.expand("~/vault/DAILY NOTES.md")

    -- Calculate window size (% of editor size)
    local width = math.floor(vim.api.nvim_get_option("columns") * 0.6)
    local height = math.floor(vim.api.nvim_get_option("lines") * 0.8)

    -- Calculate starting position to center the window
    local row = 0
    local col = math.floor((vim.api.nvim_get_option("columns") - width))

    -- Create the floating window
    local buf = vim.api.nvim_create_buf(false, true)
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Set some window options
    vim.api.nvim_win_set_option(win, "winblend", 0)
    vim.api.nvim_win_set_option(win, "wrap", true)
    vim.api.nvim_win_set_option(win, "relativenumber", true)
    vim.api.nvim_win_set_option(win, "number", true)

    -- Try to read the file into the buffer
    vim.api.nvim_command("edit " .. file_path)
end, {})

vim.keymap.set("n", "<leader>td", ":TODO<CR>", { desc = "[T]o [D]o" })

-- Custom reference overlay
vim.keymap.set("n", "<leader>ref", function()
    require("custom-reference").toggle()
end, { desc = "Toggle quick reference overlay" })

-- System clipboard integration with Ctrl+C and Ctrl+V
vim.keymap.set({"n", "v"}, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({"n", "v"}, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("i", "<C-v>", '<C-r>+', { desc = "Paste from system clipboard in insert mode" })

-- Reveal in File Explorer (Windows WSL)
vim.keymap.set("n", "<leader>ef", function()
    local file_path = vim.fn.expand("%:p")

    if file_path == "" then
        return
    end

    -- Get directory containing the file
    local dir_path = vim.fn.expand("%:p:h")

    -- Use wslpath to properly convert WSL path to Windows path
    local win_path = vim.fn.system("wslpath -w '" .. dir_path .. "'")
    win_path = win_path:gsub("\n", ""):gsub("\r", ""):gsub("\\", "\\\\") -- Remove newlines and escape backslashes

    -- Open the directory
    vim.fn.system('explorer.exe "' .. win_path .. '"')
end, { desc = "[E]xplorer reveal [F]ile" })

vim.keymap.set("n", "<leader>eo", function()
    local file_path = vim.fn.expand("%:p")

    if file_path == "" then
        return
    end

    -- Get directory containing the file
    local dir_path = vim.fn.expand("%:p:h")

    -- Use wslpath to properly convert WSL path to Windows path
    local win_path = vim.fn.system("wslpath -w '" .. dir_path .. "'")
    win_path = win_path:gsub("\n", ""):gsub("\r", ""):gsub("\\", "\\\\") -- Remove newlines and escape backslashes

    -- Open the directory
    vim.fn.system('explorer.exe "' .. win_path .. '"')
end, { desc = "[E]xplorer [O]pen current file" })

-- Avante
vim.api.nvim_create_user_command('AvanteReset', function()
    vim.cmd('AvanteClear')
    vim.cmd('AvanteRefresh')
end, {})
