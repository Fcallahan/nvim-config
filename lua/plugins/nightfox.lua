return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "nightfox" then
			require("nightfox").setup({
				options = {
					transparent = true,
				},
			})
			vim.cmd.colorscheme(selected.flavor)
		end
	end,
}
