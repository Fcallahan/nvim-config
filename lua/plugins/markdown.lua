return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        keys = {
            {
                "<leader>md",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Toggle markdown preview",
                ft = "markdown",
            },
        },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_theme = 'dark'
        end,
        ft = { "markdown" },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {},
        ft = { "markdown", "codecompanion" },
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require('render-markdown').setup({
                heading = {
                    enabled = false,
                },
                latex = { enabled = false }
            })
        end
    }
}
