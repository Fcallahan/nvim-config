return {
	"NvChad/base46",
	branch = "v3.0",
	lazy = false,
	priority = 1100,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "chadracula-evondev" then
			require("base46").load_all_highlights()
		end
	end,
}
