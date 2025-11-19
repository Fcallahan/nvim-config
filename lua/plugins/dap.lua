return {
	{
		"mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim"
        },
        config = function()
            local dap = require("dap")
            local dap_utils = require("dap.utils")
            local dotnet_helper = require("dotnet-tools.helpers")
            local ui = require("dapui")

            require("dapui").setup()

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

            local config = {
                -- EMServices Billing Rules - Web API (Development)
                {
                    type = "coreclr",
                    name = "BR: Web API - Development",
                    request = "launch",
                    program = function()
                        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            dotnet_helper.build_project()
                        end
                        return get_br_dll("EMServices.BillingRules")
                    end,
                    cwd = function()
                        local sln_dir = find_solution()
                        if sln_dir then
                            return sln_dir .. "/src/EMServices.BillingRules"
                        end
                        return vim.fn.getcwd()
                    end,
                    env = {
                        ASPNETCORE_ENVIRONMENT = "Development"
                    },
                    stopAtEntry = false,
                },
                -- EMServices Billing Rules - Web API (DevRemote)
                {
                    type = "coreclr",
                    name = "BR: Web API - DevRemote",
                    request = "launch",
                    program = function()
                        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            dotnet_helper.build_project()
                        end
                        return get_br_dll("EMServices.BillingRules")
                    end,
                    cwd = function()
                        local sln_dir = find_solution()
                        if sln_dir then
                            return sln_dir .. "/src/EMServices.BillingRules"
                        end
                        return vim.fn.getcwd()
                    end,
                    env = {
                        ASPNETCORE_ENVIRONMENT = "DevRemote"
                    },
                    stopAtEntry = false,
                },
                -- EMServices Billing Rules - Worker Service
                {
                    type = "coreclr",
                    name = "BR: Worker Service",
                    request = "launch",
                    program = function()
                        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            dotnet_helper.build_project()
                        end
                        return get_br_dll("Emservices.WorkerApp")
                    end,
                    cwd = function()
                        local sln_dir = find_solution()
                        if sln_dir then
                            return sln_dir .. "/src/Emservices.WorkerApp"
                        end
                        return vim.fn.getcwd()
                    end,
                    env = {
                        DOTNET_ENVIRONMENT = "Development"
                    },
                    stopAtEntry = false,
                },
                -- Generic Console Application (fallback for other projects)
                {
                    type = "coreclr",
                    name = "Launch Console in Development",
                    request = "launch",
                    program = function()

                        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            dotnet_helper.build_project()
                        end

                        return dotnet_helper.get_dll_path()
                    end,
                    env = {
                        DOTNET_ENVIRONMENT = "Development"
                    }
                },
                {
                    type = "coreclr",
                    name = "Launch WEB in Development",
                    request = "launch",
                    program = function()
                        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            vim.g.dotnet_build_project()
                        end

                        return dotnet_helper.get_dll_path()
                    end,
                    env = {
                        ASPNETCORE_ENVIRONMENT = "Development"
                    }
                },
                {
                    type = "coreclr",
                    name = "Attach",
                    request = "attach",
                    processId = dap_utils.pick_process,
                },

                {
                    type = "coreclr",
                    name = "Attach (Smart)",
                    request = "attach",
                    processId = function()
                        local current_working_dir = vim.fn.getcwd()
                        return dotnet_helper.dap_smart_pick_process(dap_utils, current_working_dir) or dap.ABORT
                    end,
                },
            }

            dap.configurations.cs = config
            dap.configurations.fsharp = config

            dap.adapters.netcoredbg = {
                type = 'executable',
                command = 'netcoredbg',
                args = {
                    '--interpreter=vscode',
                }
            }

            dap.adapters.coreclr = {
                type = 'executable',
                command = 'netcoredbg',
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

            vim.keymap.set("n", "<F5>", dap.continue)
            vim.keymap.set("n", "<F10>", dap.step_over)
            vim.keymap.set("n", "<F11>", dap.step_into)
            vim.keymap.set("n", "<F7>", dap.step_out)
            vim.keymap.set("n", "<F6>", dap.step_back)
            vim.keymap.set("n", "<F2>", dap.restart)
            vim.keymap.set("n", "<F4>", "<cmd>lua require'dap'.disconnect({ terminateDebuggee = true })<CR><cmd>lua require'dap'.close()<CR>")

            vim.keymap.set("n", "<leader>de", function()
                local expr = vim.fn.input("Evaluate Expression: ")
                if expr then
                    require("dapui").eval(expr)
                end
            end, { desc = "DAP: Evaluate expression" })

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
		end,
	},
}
