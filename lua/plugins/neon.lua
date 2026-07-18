return {
	"Zeioth/neon.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "neon" then
			require("neon").setup({
				style = selected.flavor or "cherrykiss-storm",
				transparent = true,
			})
			vim.cmd.colorscheme("neon")
		end
	end,
}