return {
    "nvim-neotest/neotest",
    dependencies = {
        "Nsidorenco/neotest-vstest", -- Modern VSTest-based adapter (replaces neotest-dotnet)
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
    },
    event = "VeryLazy",
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-vstest")({
                    -- Use project-based discovery for better reliability
                    discovery_root = "project",

                    -- Force Debug builds for better debugging experience
                    extra_args = { "-c", "Debug" },

                    -- DAP strategy configuration for netcoredbg
                    dap = {
                        adapter_name = "netcoredbg",
                        args = { justMyCode = false },
                    },
                }),
            },
        })

        local neotest = require("neotest")

        -- Buffer-local test debugging: set breakpoint + press <leader>dt
        vim.keymap.set("n", "<leader>dt", function()
            neotest.run.run({ strategy = "dap" })
        end, { desc = "Debug nearest test", noremap = true, silent = true })

        -- Additional useful test commands
        vim.keymap.set("n", "<leader>tr", function()
            neotest.run.run()
        end, { desc = "Run nearest test", noremap = true, silent = true })

        vim.keymap.set("n", "<leader>tf", function()
            neotest.run.run(vim.fn.expand("%"))
        end, { desc = "Run all tests in file", noremap = true, silent = true })
    end,
}
