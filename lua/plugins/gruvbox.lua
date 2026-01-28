return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local theme_selector = require("tuliopaim.theme-selector")
		local selected = theme_selector.select_random_theme()

		if selected.name == "gruvbox" then
			require("gruvbox").setup({
				transparent_mode = true,
			})

			if selected.setup_fn then
				selected.setup_fn(selected.flavor)
			end

			vim.cmd.colorscheme("gruvbox")
		end
	end,
}
