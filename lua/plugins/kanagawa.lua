return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "kanagawa" then
			require("kanagawa").setup({
				theme = selected.flavor,
				transparent = true,
				background = {
					dark = selected.flavor,
					light = "lotus",
				},
			})
			vim.cmd.colorscheme("kanagawa")
		end
	end,
}
