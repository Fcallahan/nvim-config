return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "tokyonight" then
			require("tokyonight").setup({
				style = selected.flavor,
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
			vim.cmd.colorscheme("tokyonight")
		end
	end,
}
