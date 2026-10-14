-- Custom command for CLI-style find/replace
-- Usage: :FindReplace foo bar src/**/*.cs
vim.api.nvim_create_user_command('PiReview', function()
    local ok, mod = pcall(require, "tuliopaim.pi_review")
    if not ok then
        vim.notify("pi_review module not available", vim.log.levels.ERROR)
        return
    end
    mod.start()
end, { desc = "Start a review launched from Pi's /review command" })

vim.api.nvim_create_user_command('HelpReview', function()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.min(70, vim.o.columns - 10)
    local height = 20
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Pi Review Keymaps ",
    })
    vim.bo[buf].filetype = "help"
    vim.bo[buf].modifiable = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = true
    vim.wo.winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

    local lines = {
        "╭──────────────────────────────────────────────╮",
        "│              Pi Review Shortcuts              │",
        "├──────────────────────────────────────────────┤",
        "│                                              │",
        "│  Add / edit comment    <Space>rc              │",
        "│  Delete comment        <Space>rd              │",
        "│  Toggle resolved       <Space>rx              │",
        "│  Save review           <Space>rs              │",
        "│  Save + quit           <Space>rq              │",
        "│  Next comment          <Space>rn              │",
        "│  Prev comment          <Space>rp              │",
        "│  Next file             ]f                     │",
        "│  Prev file             [f                     │",
        "│  Restart (clear all)   <Space>rR              │",
        "│                                              │",
        "╰──────────────────────────────────────────────╯",
        "                                                  ",
        "  (press q or <Esc> to close)                     ",
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(vim.api.nvim_get_current_win()) then
            vim.api.nvim_win_close(0, true)
        end
    end, { buffer = buf, silent = true, nowait = true })
    vim.keymap.set("n", "<Esc>", function()
        if vim.api.nvim_win_is_valid(vim.api.nvim_get_current_win()) then
            vim.api.nvim_win_close(0, true)
        end
    end, { buffer = buf, silent = true, nowait = true })
end, { desc = "Show Pi Review keymap help" })

vim.api.nvim_create_user_command('FindReplace', function(opts)
    local args = vim.split(opts.args, ' ')
    if #args >= 2 then
        require('grug-far').grug_far({
            prefills = {
                search = args[1],
                replacement = args[2],
                paths = args[3] or ''
            }
        })
    else
        vim.notify("Usage: FindReplace <search> <replacement> [paths]", vim.log.levels.ERROR)
    end
end, { nargs = '+' })
