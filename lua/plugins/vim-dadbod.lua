return {
    {
        "kristijanhusak/vim-dadbod-ui",
        lazy = true,
        dependencies = {
            { "tpope/vim-dadbod",                     lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
            "DBUIShowConnections",
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_winwidth = 30
            vim.g.db_ui_show_help = 0
            vim.g.db_ui_use_nvim_notify = 0  -- Disabled to prevent conflicts with Snacks notifier
            vim.g.db_ui_win_position = "left"
            vim.g.db_ui_execute_on_save = 0
        end,
        config = function()
            -- Function to view DBUI connections
            local function view_dbui_connections()
                local connections_file = vim.fn.expand("~/.local/share/db_ui/connections.json")

                -- Check if file exists
                if vim.fn.filereadable(connections_file) == 0 then
                    vim.notify("No DBUI connections found", vim.log.levels.WARN)
                    return
                end

                -- Read and parse the connections file
                local file = io.open(connections_file, "r")
                if not file then
                    vim.notify("Could not open connections file", vim.log.levels.ERROR)
                    return
                end

                local content = file:read("*all")
                file:close()

                local ok, connections = pcall(vim.json.decode, content)
                if not ok or not connections then
                    vim.notify("Could not parse connections file", vim.log.levels.ERROR)
                    return
                end

                -- Create a buffer with the formatted connections
                local buf = vim.api.nvim_create_buf(false, true)
                local lines = { "DBUI Connections", "================", "" }

                for i, conn in ipairs(connections) do
                    table.insert(lines, string.format("%d. Name: %s", i, conn.name or "Unnamed"))
                    table.insert(lines, string.format("   URL:  %s", conn.url or "No URL"))
                    table.insert(lines, "")
                end

                vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                vim.api.nvim_buf_set_option(buf, "modifiable", false)
                vim.api.nvim_buf_set_option(buf, "filetype", "dbui-connections")

                -- Open in a floating window
                local width = math.min(120, vim.o.columns - 4)
                local height = math.min(#lines + 2, vim.o.lines - 4)
                local row = math.floor((vim.o.lines - height) / 2)
                local col = math.floor((vim.o.columns - width) / 2)

                local opts = {
                    relative = "editor",
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                    style = "minimal",
                    border = "rounded",
                    title = " DBUI Connections ",
                    title_pos = "center",
                }

                local win = vim.api.nvim_open_win(buf, true, opts)

                -- Set buffer keymaps
                vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
            end

            -- Create user command
            vim.api.nvim_create_user_command("DBUIShowConnections", view_dbui_connections, {
                desc = "Show DBUI connection URLs"
            })

            -- Keymap to open connections.json
            vim.keymap.set("n", "<leader>dc", function()
                local connections_file = vim.fn.expand("~/.local/share/db_ui/connections.json")
                vim.cmd("edit " .. connections_file)
            end, { desc = "Open DBUI connections.json" })

            -- Define highlight setter functions
            local function set_dbui_highlights()
                -- DBUI drawer colors (override plugin defaults)
                vim.api.nvim_set_hl(0, "dbui_connection_ok", { fg = "#a6e3a1", bold = true })      -- Green
                vim.api.nvim_set_hl(0, "dbui_connection_error", { fg = "#f38ba8", bold = true })   -- Red
                vim.api.nvim_set_hl(0, "dbui_help", { fg = "#89b4fa", italic = true })             -- Blue
                vim.api.nvim_set_hl(0, "dbui_help_key", { fg = "#f9e2af", bold = true })           -- Yellow
            end

            local function set_dbout_highlights()
                -- Query result table highlights
                vim.api.nvim_set_hl(0, "dbout_header", { fg = "#cdd6f4", bold = true, underline = true })
                vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" })
            end

            -- Set highlights immediately when plugin loads (for current buffer)
            vim.schedule(function()
                set_dbui_highlights()
                set_dbout_highlights()
            end)

            -- Re-apply highlights when colorscheme changes
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("DBUIHighlights", { clear = true }),
                callback = function()
                    vim.schedule(function()
                        set_dbui_highlights()
                        set_dbout_highlights()
                    end)
                end,
            })

            -- Set highlights when FileType is detected (for new buffers)
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("DBUIFileType", { clear = true }),
                pattern = "dbui",
                callback = function()
                    vim.schedule(set_dbui_highlights)
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("DBOUTFileType", { clear = true }),
                pattern = "dbout",
                callback = function()
                    -- Set buffer-local options
                    vim.opt_local.wrap = false
                    vim.opt_local.cursorline = true
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false

                    -- Set highlights after a slight delay to ensure they override plugin defaults
                    vim.schedule(set_dbout_highlights)
                end,
            })

            -- Better notification colors for query status
            vim.api.nvim_set_hl(0, "NotificationInfo", { fg = "#89dceb", bg = "#1e1e2e" })
            vim.api.nvim_set_hl(0, "NotificationWarning", { fg = "#fab387", bg = "#1e1e2e" })
            vim.api.nvim_set_hl(0, "NotificationError", { fg = "#f38ba8", bg = "#1e1e2e" })
        end,
    },
}
