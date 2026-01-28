return {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
        local theme_selector = require("tuliopaim.theme-selector")
        local selected = theme_selector.select_random_theme()

        require("catppuccin").setup({
            flavour = selected.name == "catppuccin" and selected.flavor or "mocha", -- latte, frappe, macchiato, mocha
            integrations = {
                cmp = true,
                gitsigns = true,
                harpoon = true,
                illuminate = true,
                indent_blankline = {
                    enabled = false,
                    scope_color = "sapphire",
                    colored_indent_levels = false,
                },
                mason = true,
                native_lsp = { enabled = true },
                notify = true,
                nvimtree = true,
                neotree = true,
                symbols_outline = true,
                telescope = false,
                treesitter = true,
                treesitter_context = true,
            },
            transparent_background = true,
            float = {
                transparent = true,
            },
        })

        if selected.name == "catppuccin" then
            vim.cmd.colorscheme("catppuccin")
        end
    end
}
