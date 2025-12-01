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
                    -- DAP configuration for debugging
                    dap_settings = {
                        type = "netcoredbg",
                        justMyCode = false,  -- Allow debugging with fewer symbols, prevents "release build" warnings
                    },
                    -- Note: Debug builds are used by default, no need for build_opts
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

        -- Test Explorer UI
        vim.keymap.set("n", "<leader>te", function()
            neotest.summary.toggle()
        end, { desc = "Toggle test explorer", noremap = true, silent = true })

        vim.keymap.set("n", "<leader>to", function()
            neotest.output_panel.toggle()
        end, { desc = "Toggle test output panel", noremap = true, silent = true })

        vim.keymap.set("n", "<leader>tS", function()
            neotest.run.stop()
        end, { desc = "Stop running tests", noremap = true, silent = true })
    end,
}
