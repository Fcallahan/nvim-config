return {
	"Everblush/nvim",
	name = "everblush",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "everblush" then
			vim.g.everblush_transparent = true
			vim.cmd.colorscheme("everblush")
		end
	end,
}