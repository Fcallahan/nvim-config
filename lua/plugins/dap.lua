return {
	{
		"mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim"
        },
        config = function()
            local dap = require("dap")
            local dap_utils = require("dap.utils")
            local dotnet_helper = require("dotnet-tools.helpers")
            local ui = require("dapui")

            -- Exception breakpoint state (toggleable)
            local exception_breakpoints = {
                enabled = false,
                filters = {}  -- empty = off, {"all"} = all exceptions, {"user-unhandled"} = unhandled only
            }

            -- Set exception breakpoints on the current session
            local function apply_exception_breakpoints()
                if dap.session() then
                    dap.set_exception_breakpoints(exception_breakpoints.filters)
                end
            end

            -- Toggle exception modes: off -> user-unhandled -> all -> off
            local function cycle_exception_breakpoints()
                if #exception_breakpoints.filters == 0 then
                    exception_breakpoints.filters = { "user-unhandled" }
                    exception_breakpoints.enabled = true
                    vim.notify("Exception breakpoints: USER-UNHANDLED", vim.log.levels.INFO)
                elseif exception_breakpoints.filters[1] == "user-unhandled" then
                    exception_breakpoints.filters = { "all" }
                    vim.notify("Exception breakpoints: ALL (first-chance)", vim.log.levels.INFO)
                else
                    exception_breakpoints.filters = {}
                    exception_breakpoints.enabled = false
                    vim.notify("Exception breakpoints: OFF", vim.log.levels.INFO)
                end
                apply_exception_breakpoints()
            end

            -- Enhanced dapui layout with better organization
            ui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    edit = "e",
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    repl = "r",
                    toggle = "t",
                },
                expand_lines = true,
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.35 },      -- Variable scopes
                            { id = "breakpoints", size = 0.15 }, -- Breakpoints list
                            { id = "stacks", size = 0.25 },      -- Call stack
                            { id = "watches", size = 0.25 },     -- Watch expressions
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },     -- REPL for executing code
                            { id = "console", size = 0.5 },  -- Program output
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                controls = {
                    enabled = true,
                    element = "repl",
                },
                floating = {
                    max_width = 0.9,
                    max_height = 0.5,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 2 },
            })

            -- Enable inline variable viewing with nvim-dap-virtual-text
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                only_first_definition = true,
                all_references = false,
                clear_on_continue = false,
                virt_text_pos = vim.fn.has('nvim-0.10') == 1 and 'inline' or 'eol',
            })

            -- Custom highlight groups for better visibility (Catppuccin-friendly)
            vim.api.nvim_set_hl(0, 'DapStopped', {
                fg = '#a6e3a1',  -- Catppuccin green
                bg = '#45475a',  -- Catppuccin dark gray
                bold = true,
            })
            vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#f38ba8' })
            vim.api.nvim_set_hl(0, 'NvimDapVirtualText', { fg = '#888888', italic = true })
            vim.api.nvim_set_hl(0, 'NvimDapVirtualTextChanged', { fg = '#ff9900', italic = true })

            -- Sign definitions with better symbols
            vim.fn.sign_define('DapBreakpoint', {
                text = '●',
                texthl = 'DapBreakpoint',
                linehl = '',
                numhl = 'DapBreakpoint'
            })
            vim.fn.sign_define('DapStopped', {
                text = '▶',
                texthl = 'DapStopped',
                linehl = 'DapStopped',  -- Highlights entire current line
                numhl = 'DapStopped'
            })

            -- Helper function to find solution directory
            local find_solution = function()
                local current_file = vim.fn.expand("%:p")
                if current_file == "" then
                    current_file = vim.fn.getcwd()
                end
                local search_dir = vim.fn.fnamemodify(current_file, ":h")
                for _ = 1, 10 do
                    local sln_files = vim.fn.glob(search_dir .. "/*.sln", false, true)
                    if #sln_files > 0 then
                        return vim.fn.fnamemodify(sln_files[1], ":h")
                    end
                    local parent = vim.fn.fnamemodify(search_dir, ":h")
                    if parent == search_dir then break end
                    search_dir = parent
                end
                return nil
            end

            -- Helper to find DLL for Billing Rules projects
            local get_br_dll = function(project_name)
                local sln_dir = find_solution()
                if not sln_dir then
                    return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net9.0/', 'file')
                end
                local dll_path = sln_dir .. "/src/" .. project_name .. "/bin/Debug/net9.0/" .. project_name .. ".dll"
                if vim.fn.filereadable(dll_path) == 1 then
                    return dll_path
                end
                return vim.fn.input('Path to dll: ', sln_dir .. '/bin/Debug/net9.0/', 'file')
            end

            -- Use Mason-installed netcoredbg
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

            dap.adapters.netcoredbg = {
                type = 'executable',
                command = mason_path,
                args = {
                    '--interpreter=vscode',
                }
            }

            dap.adapters.coreclr = {
                type = 'executable',
                command = mason_path,
                args = {
                    '--interpreter=vscode',
                }
            }

            vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
            vim.keymap.set("n", "<s-F9>", function()
                local condition = vim.fn.input("Breakpoint Condition: ")
                if condition then
                    dap.set_breakpoint(condition)
                end
                end, { desc = "DAP: Set conditional breakpoint" })

            -- Debugger controls (matching tutorial keybindings)
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue/Start" })
            vim.keymap.set("n", "<F6>", function()
                -- Debug nearest test (requires neotest-dotnet)
                local neotest_ok, neotest = pcall(require, "neotest")
                if neotest_ok then
                    neotest.run.run({ strategy = "dap" })
                else
                    vim.notify("neotest not available", vim.log.levels.WARN)
                end
            end, { desc = "DAP: Debug nearest test" })
            vim.keymap.set("n", "<F8>", dap.step_out, { desc = "DAP: Step out" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
            vim.keymap.set("n", "<F2>", dap.restart, { desc = "DAP: Restart" })
            vim.keymap.set("n", "<F4>", "<cmd>lua require'dap'.disconnect({ terminateDebuggee = true })<CR><cmd>lua require'dap'.close()<CR>", { desc = "DAP: Stop and close" })

            -- Alternative keybindings (for terminals that intercept F-keys)
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]ebug: [C]ontinue/Start" })
            vim.keymap.set("n", "<leader>dv", dap.step_over, { desc = "[D]ebug: Step o[V]er" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebug: Step [I]nto" })
            vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[D]ebug: Step [O]ut" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebug: Toggle [B]reakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                local condition = vim.fn.input("Breakpoint Condition: ")
                if condition and condition ~= "" then
                    dap.set_breakpoint(condition)
                end
            end, { desc = "[D]ebug: Conditional [B]reakpoint" })

            -- Exception breakpoint controls
            vim.keymap.set("n", "<leader>dE", cycle_exception_breakpoints,
                { desc = "[D]ebug: Cycle [E]xception breakpoints (off/unhandled/all)" })

            vim.keymap.set("n", "<leader>deu", function()
                exception_breakpoints.filters = { "user-unhandled" }
                exception_breakpoints.enabled = true
                apply_exception_breakpoints()
                vim.notify("Exception breakpoints: USER-UNHANDLED", vim.log.levels.INFO)
            end, { desc = "[D]ebug: [E]xception break on [U]nhandled" })

            vim.keymap.set("n", "<leader>dea", function()
                exception_breakpoints.filters = { "all" }
                exception_breakpoints.enabled = true
                apply_exception_breakpoints()
                vim.notify("Exception breakpoints: ALL", vim.log.levels.INFO)
            end, { desc = "[D]ebug: [E]xception break on [A]ll" })

            vim.keymap.set("n", "<leader>deo", function()
                exception_breakpoints.filters = {}
                exception_breakpoints.enabled = false
                apply_exception_breakpoints()
                vim.notify("Exception breakpoints: OFF", vim.log.levels.INFO)
            end, { desc = "[D]ebug: [E]xception breakpoints [O]ff" })

            vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "[D]ebug: [R]estart" })
            vim.keymap.set("n", "<leader>dx", function()
                dap.disconnect({ terminateDebuggee = true })
                dap.close()
            end, { desc = "[D]ebug: Stop/e[X]it" })

            -- Nuclear cleanup - forcefully terminate everything
            vim.keymap.set("n", "<leader>dX", function()
                require('dap').terminate()
                require('dap').disconnect({ terminateDebuggee = true })
                require('dap').close()
                require('dapui').close()
                require('nvim-dap-virtual-text').refresh()
                vim.notify("DAP session cleaned up", vim.log.levels.INFO)
            end, { desc = "[D]ebug: Force cleanup (nuclear)" })

            -- User command for easy access
            vim.api.nvim_create_user_command('DapCleanup', function()
                require('dap').terminate()
                require('dap').disconnect({ terminateDebuggee = true })
                require('dap').close()
                require('dapui').close()
                require('nvim-dap-virtual-text').refresh()
                vim.notify("DAP session cleaned up", vim.log.levels.INFO)
            end, { desc = "Force cleanup all DAP connections" })

            vim.keymap.set("n", "<leader>de", function()
                local expr = vim.fn.input("Evaluate Expression: ")
                if expr then
                    require("dapui").eval(expr)
                end
            end, { desc = "DAP: Evaluate expression" })

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                local expr = vim.fn.expand("<cexpr>")
                if expr == "" then
                    expr = vim.fn.expand("<cword>")
                end
                require("dapui").eval(expr, { enter = true })
            end, { desc = "DAP: Evaluate variable under cursor" })

            -- Evaluate selection in visual mode
            vim.keymap.set("v", "<space>?", function()
                require("dapui").eval()
            end, { desc = "DAP: Evaluate selection" })

            -- Toggle UI panels
            vim.keymap.set("n", "<leader>dS", function()
                require("dapui").toggle({ layout = 1 })
            end, { desc = "[D]ebug: Toggle [S]copes sidebar" })

            vim.keymap.set("n", "<leader>dC", function()
                require("dapui").toggle({ layout = 2 })
            end, { desc = "[D]ebug: Toggle [C]onsole" })

            -- Telescope DAP integration for searching variables
            pcall(function()
                require("telescope").load_extension("dap")
            end)

            vim.keymap.set("n", "<leader>dvar", function()
                require("telescope").extensions.dap.variables()
            end, { desc = "[D]ebug: Search [VAR]iables" })

            vim.keymap.set("n", "<leader>dfr", function()
                require("telescope").extensions.dap.frames()
            end, { desc = "[D]ebug: Jump [FR]ames" })

            -- Quick debug with launchSettings.json
            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end

            -- Apply exception breakpoints when session initializes
            dap.listeners.after.event_initialized.exception_breakpoints = function()
                if exception_breakpoints.enabled then
                    apply_exception_breakpoints()
                end
            end

            dap.listeners.before.event_terminated.dapui_config = function(session, body)
                -- Check if we stopped due to exception - give time to inspect
                if body and body.reason == "exception" then
                    vim.notify("Program terminated with exception - UI staying open", vim.log.levels.WARN)
                    -- Don't auto-close, let user close manually with <leader>dx
                    return
                end
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
		end,
	},
}
