local on_attach = function(_, bufnr)
    vim.keymap.set("n", 'gd', function() Snacks.picker.lsp_definitions() end, { buffer = bufnr, desc = '[G]oto [D]efinition' })
    vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { buffer = bufnr, desc = "LSP: [G]oto [R]eferences" })
    vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, { buffer = bufnr, desc = "[G]o to [I]mplementations" })
    vim.keymap.set("n", "<leader>ds", function() Snacks.picker.lsp_symbols() end, { buffer = bufnr, desc = "[D]ocument [S]ymbols" })
    vim.keymap.set("n", "<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, { buffer = bufnr, desc = "[W]orkspace [S]ymbols" })
    vim.keymap.set("n", "<leader>cl", function() vim.lsp.codelens.refresh() end, { buffer = bufnr, desc = "[C]ode [L]ens" })
    vim.keymap.set("n", "<leader>ih", function() vim.lsp.inlay_hint.enable() end, { buffer = bufnr, desc = "[C]ode [L]ens" })

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {buffer = bufnr, desc = "[R]e[n]ame"})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer = bufnr, desc = "[C]ode [A]ction"})

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = bufnr, desc = "Hover Documentation"})
    vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, {buffer = bufnr, desc = "Float Documentation"})
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, {buffer = bufnr, desc = "Signature Help"})

    vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, {buffer = bufnr, desc = "Signature Help"})
end

return {

    { "williamboman/mason.nvim", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "folke/neodev.nvim",
            "Decodetalkers/csharpls-extended-lsp.nvim",
            "folke/snacks.nvim"
        },
        config = function()
            vim.diagnostic.config({
                virtual_text = true,
                severity_sort = true,
                float = {
                    style = 'minimal',
                    border = 'rounded',
                    header = '',
                    prefix = '',
                },
            })

            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require('blink-cmp').get_lsp_capabilities()
            )

            -- Set default configuration for all servers
            vim.lsp.config('*', {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- csharp_ls LSP Configuration (Better WSL compatibility)
            vim.lsp.config.csharp_ls = {
                on_attach = on_attach,
                capabilities = capabilities,

                -- Root directory detection
                root_dir = vim.fs.root(0, {
                    "*.sln",
                    "*.csproj",
                    "*.fsproj",
                    ".git",
                }),

                -- File types
                filetypes = { "cs" },

                -- Custom handlers with better error handling
                handlers = {
                    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
                    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
                },

                -- Initialize options
                cmd_env = {
                    DOTNET_ROOT = vim.fn.expand("~/.dotnet")
                },
            }

            -- Configure lua_ls
            vim.lsp.config.lua_ls = {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        format = { enable = false },
                        telemetry = { enable = false },
                        workspace = { checkThirdParty = false },
                        diagnostics = { globals = { "vim" } }
                    },
                },
            }

            -- Configure gopls
            vim.lsp.config.gopls = {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        staticcheck = true,
                        gofumpt = false,
                    },
                },
            }

            -- csharp_ls is configured above as the primary C# LSP server
            -- OmniSharp and Roslyn LSP are disabled for better WSL compatibility

            -- Configure pylsp
            vim.lsp.config.pylsp = {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        pyflakes = { enabled = false },
                        pycodestayle = { enabled = false },
                        autopep8 = { enabled = false },
                        yapf = { enabled = false },
                        mccabe = { enabled = false },
                        pylsp_mypy = { enabled = false },
                        pylsp_black = { enabled = false },
                        pylsp_isort = { enabled = false },
                    },
                },
            }

            require("mason-lspconfig").setup {
                ensure_installed = {
                    "csharp_ls",  -- Using csharp-ls for better WSL compatibility
                    "cssls",
                    "docker_compose_language_service",
                    "dockerls",
                    "eslint",
                    "ts_ls"
                },
                automatic_installation = true
            }
        end,
    }
}
