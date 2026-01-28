return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({
            engine = 'ripgrep',
            windowCreationCommand = 'vsplit',
            keymaps = {
                replace = { n = '<leader>r' },
                qflist = { n = '<leader>q' },
                syncLocations = { n = '<leader>s' },
                syncLine = { n = '<leader>l' },
                close = { n = '<leader>x' },
                historyOpen = { n = '<leader>t' },
                historyAdd = { n = '<leader>a' },
                refresh = { n = '<leader>f' },
                gotoLocation = { n = '<enter>' },
                pickHistoryEntry = { n = '<enter>' },
            },
        })
    end,
    keys = {
        {
            "<leader>sr",
            function()
                require('grug-far').grug_far({
                    prefills = { search = vim.fn.expand("<cword>") }
                })
            end,
            desc = "[S]earch and [R]eplace (word under cursor)"
        },
        {
            "<leader>sR",
            function()
                require('grug-far').grug_far()
            end,
            desc = "[S]earch and [R]eplace (empty)"
        },
        {
            "<leader>sf",
            function()
                require('grug-far').grug_far({
                    prefills = { paths = vim.fn.expand("%") }
                })
            end,
            desc = "[S]earch and replace in current [F]ile"
        },
    },
}
