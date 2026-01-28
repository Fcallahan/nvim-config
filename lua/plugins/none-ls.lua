return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim'
    },
    config = function()

        require("mason-null-ls").setup {
            ensure_installed = {
                "prettier",
                "stylua", 
                "csharpier",
            },
            automatic_installation = true
        }

        require("null-ls").setup()

        local null_ls = require("null-ls")

        null_ls.setup({
            border = "rounded",
            sources = {
                require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I'} },
                require('none-ls.formatting.ruff_format'),
                null_ls.builtins.formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
                null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.csharpier,
            },
        })

        vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})

        -- Auto-format on save with toggle
        vim.g.auto_format_enabled = true

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function()
                if vim.g.auto_format_enabled then
                    vim.lsp.buf.format({ async = false })
                end
            end,
        })

    end,
}
