return {
	"frenzyexists/aquarium-vim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "aquarium" then
			vim.cmd.colorscheme("aquarium")
		end
	end,
}
