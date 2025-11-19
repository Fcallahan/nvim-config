return {
    "nvim-neotest/neotest",
    dependencies = {
        "Issafalcon/neotest-dotnet",
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
    },
    event = "VeryLazy",
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-dotnet")
            }
        })

        local neotest = require("neotest")

        -- User commands
        vim.api.nvim_create_user_command('TestDebug', function() neotest.run.run({strategy = "dap"}) end, {})

        -- Keymappings (matching tutorial)
        vim.keymap.set("n", "<leader>dt", function()
            neotest.run.run({ strategy = "dap" })
        end, { desc = "Debug nearest test", noremap = true, silent = true })
    end,
}
