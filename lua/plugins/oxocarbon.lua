return {
	"nyoom-engineering/oxocarbon.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "oxocarbon" then
			require("oxocarbon").setup({
				transparent = true,
			})
			vim.cmd.colorscheme("oxocarbon")
		end
	end,
}