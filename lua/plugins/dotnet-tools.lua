return {
    "dotnet-tools",
    dir = "~/.config/nvim/lua/tuliopaim/dotnet-tools",
    event = "VeryLazy",
    keys = {
        {
            "<leader>rt",
            ":Test<CR>",
            desc="Run test at cursor"
        },
        {
            "<leader>rc",
            ":TestClass<CR>",
            desc="Run test class"
        },
        {
            "<leader>rl",
            function()
                require("dotnet-tools.launcher").show_launcher()
            end,
            desc="Run/Debug Launcher (BR)"
        },
    },
    config = function()
        require("dotnet-tools").setup({
            script_path = "/home/tuliopaim/.nix-profile/bin/rider"
        })

        -- Setup the launcher module
        require("dotnet-tools.launcher").setup()
    end
}
