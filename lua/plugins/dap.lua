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

            -- Enable verbose DAP logging
            dap.set_log_level('TRACE')

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

            -- Minimalist dapui layout
            ui.setup({
                expand_lines = true,
                controls = { enabled = false },
                floating = { border = "rounded" },
                render = {
                    max_type_length = 60,
                    max_value_lines = 200,
                },
                layouts = {
                    {
                        elements = {
                            { id = "repl", size = 1.0 },
                        },
                        size = 15,
                        position = "bottom",
                    },
                    {
                        elements = {
                            { id = "scopes", size = 1.0 },
                        },
                        size = 70,
                        position = "right",
                    },
                },
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

            -- Helper function to find and kill process on a specific port
            local function kill_process_on_port(port)
                if not port then return false end

                -- Use 'ss' to find process using the port (reliable in WSL)
                local cmd = string.format("ss -tlnp 2>/dev/null | grep ':%d ' | grep -oP 'pid=\\K[0-9]+'", port)
                local handle = io.popen(cmd)
                local pid_str = handle:read("*a")
                handle:close()

                if pid_str and pid_str ~= "" then
                    local pid = tonumber(pid_str:match("%d+"))
                    if pid then
                        vim.notify(string.format("Found process %d on port %d, terminating...", pid, port), vim.log.levels.WARN)
                        -- Try SIGTERM first, then SIGKILL
                        os.execute(string.format("kill -TERM %d 2>/dev/null || kill -KILL %d 2>/dev/null", pid, pid))
                        -- Verify after 1 second
                        vim.defer_fn(function()
                            if os.execute(string.format("ps -p %d > /dev/null 2>&1", pid)) == 0 then
                                vim.notify(string.format("Process %d still alive, force killing...", pid), vim.log.levels.WARN)
                                os.execute(string.format("kill -9 %d 2>/dev/null", pid))
                            end
                        end, 1000)
                        return true
                    end
                end
                return false
            end

            -- Helper to extract port from debug config
            local function get_port_from_config(config)
                if not config then return nil end

                local env = config.env or {}
                local app_url = env.ASPNETCORE_URLS or ""

                -- Parse port from ASPNETCORE_URLS (format: "http://localhost:5156")
                local port = app_url:match(":(%d+)")
                return port and tonumber(port) or nil
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
                local last_config = dap.session() and dap.session().config or nil
                local port = get_port_from_config(last_config)

                dap.disconnect({ terminateDebuggee = true })
                dap.close()

                -- Also clean up port on regular exit
                if port then
                    vim.defer_fn(function()
                        kill_process_on_port(port)
                    end, 500)
                end
            end, { desc = "[D]ebug: Stop/e[X]it" })

            -- Nuclear cleanup - forcefully terminate everything
            vim.keymap.set("n", "<leader>dX", function()
                local dap = require('dap')
                local last_config = dap.session() and dap.session().config or nil
                local port = get_port_from_config(last_config)

                -- Standard cleanup sequence
                dap.terminate()
                dap.disconnect({ terminateDebuggee = true })
                dap.close()
                require('dapui').close()
                require('nvim-dap-virtual-text').refresh()

                -- Schedule port cleanup check after brief delay for graceful shutdown
                if port then
                    vim.defer_fn(function()
                        if kill_process_on_port(port) then
                            vim.notify(string.format("DAP session cleaned up (forcefully killed process on port %d)", port), vim.log.levels.INFO)
                        else
                            vim.notify("DAP session cleaned up", vim.log.levels.INFO)
                        end
                    end, 500)  -- Wait 500ms for graceful shutdown
                else
                    vim.notify("DAP session cleaned up", vim.log.levels.INFO)
                end
            end, { desc = "[D]ebug: Force cleanup (nuclear)" })

            -- User command for easy access
            vim.api.nvim_create_user_command('DapCleanup', function()
                local dap = require('dap')
                local last_config = dap.session() and dap.session().config or nil
                local port = get_port_from_config(last_config)

                dap.terminate()
                dap.disconnect({ terminateDebuggee = true })
                dap.close()
                require('dapui').close()
                require('nvim-dap-virtual-text').refresh()

                if port then
                    vim.defer_fn(function()
                        if kill_process_on_port(port) then
                            vim.notify(string.format("DAP session cleaned up (forcefully killed process on port %d)", port), vim.log.levels.INFO)
                        else
                            vim.notify("DAP session cleaned up", vim.log.levels.INFO)
                        end
                    end, 500)
                else
                    vim.notify("DAP session cleaned up", vim.log.levels.INFO)
                end
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

            -- Keep console open on program termination/exit for inspection
            -- User must manually close with <leader>dx
            dap.listeners.before.event_terminated.dapui_config = function(session, body)
                vim.notify("Program terminated - console staying open. Close with <leader>dx", vim.log.levels.INFO)
                -- Don't auto-close UI, let user close manually
            end
            dap.listeners.before.event_exited.dapui_config = function()
                -- Don't auto-close UI on exit either
            end
		end,
	},
}
