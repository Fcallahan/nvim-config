return {
    "nvim-neotest/neotest",
    dependencies = {
        -- NOTE: Disabled neotest-dotnet due to stack overflow bugs in test discovery
        -- Using easy-dotnet.nvim test runner instead for C# test debugging
        -- "Issafalcon/neotest-dotnet",
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
    },
    enabled = false, -- Disabled: using easy-dotnet.nvim test runner instead
    event = "VeryLazy",
    config = function()
        require("neotest").setup({
            adapters = {
                -- DISABLED: neotest-dotnet has stack overflow issues with xunit test discovery
                -- Migrated to easy-dotnet.nvim which has built-in test debugging with auto DLL detection
                -- require("neotest-dotnet")({
                --     discovery_root = "project",
                --     dotnet_additional_args = {
                --         "-c",
                --         "Debug"
                --     }
                -- })
            }
        })

        -- NOTE: <leader>dt keybinding is now handled by easy-dotnet.nvim test runner
        -- See lua/plugins/easy-dotnet.lua for test debugging configuration
    end,
}
