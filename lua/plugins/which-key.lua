return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        delay = 1000, -- Time in milliseconds to wait before showing which-key
        win = {
            border = "rounded",
            padding = { 1, 2 },
        },
        layout = {
            width = { min = 20 },
            spacing = 3,
        },
        keys = {
            scroll_down = "<c-d>",
            scroll_up = "<c-u>",
        },
        -- Disable for certain modes and operators
        disable = {
            buftypes = {},
            filetypes = { "TelescopePrompt" },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        
        -- Register key groups for better organization
        wk.add({
            { "<leader>c", group = "Code" },
            { "<leader>d", group = "Debug/Diagnostics" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>r", group = "Resize/Run" },
            { "<leader>t", group = "Tab/Test/Todo" },
            { "<leader>u", group = "UI/Undo" },
            { "<leader>w", group = "Workspace" },
            { "<leader>x", group = "Trouble" },
            { "<leader>n", group = "Neovim/Notes" },
            { "<leader>l", group = "LSP" },
            { "<leader>o", group = "Open" },
            { "<leader>e", group = "Explorer" },
            { "[", group = "Previous" },
            { "]", group = "Next" },
            { "g", group = "Goto" },
        })
    end,
}