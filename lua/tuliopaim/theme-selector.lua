local M = {}

--M.active_theme = "chadracula-evondev"
M.active_theme = "neon"

-- Theme registry with available themes and their variants
M.themes = {
	{
		name = "tokyonight",
		flavors = { "night", "storm", "moon" },
		lualine_name = "tokyonight",
	},
	{
		name = "aquarium",
		flavors = { "aquarium" },
		lualine_name = "auto",
	},
	{
		name = "chadracula-evondev",
		flavors = { "chadracula-evondev" },
		lualine_name = "auto",
	},
	{
		name = "neon",
		flavors = { "cherrykiss-storm", "cyberpunk-storm", "netrunner-storm", "punkpeach-storm", "cherrykiss-night", "cyberpunk-night", "netrunner-night", "punkpeach-night" },
		lualine_name = "auto",
	},
	{
		name = "everblush",
		flavors = { "everblush" },
		lualine_name = "auto",
	},
	{
		name = "oxocarbon",
		flavors = { "oxocarbon" },
		lualine_name = "auto",
	},
}

-- Select a random theme from the registry
-- This function is called by theme plugins during startup
-- Returns cached selection if already chosen (prevents re-randomization)
function M.select_random_theme()
	-- Return cached selection if it already exists
	if vim.g.current_theme_selection then
		return vim.g.current_theme_selection
	end

	if M.active_theme then
		for _, theme in ipairs(M.themes) do
			if theme.name == M.active_theme then
				local selection = {
					name = theme.name,
					flavor = theme.flavors[1],
					lualine_name = theme.lualine_name,
					setup_fn = theme.setup_fn,
				}

				vim.g.current_theme_selection = selection
				return selection
			end
		end
	end

	-- Generate truly random selection using current time as seed
	math.randomseed(os.time())

	-- Randomly select a theme from the registry
	local theme_idx = math.random(1, #M.themes)
	local theme = M.themes[theme_idx]

	-- Randomly select a flavor from the chosen theme
	local flavor_idx = math.random(1, #theme.flavors)
	local flavor = theme.flavors[flavor_idx]

	-- Build selection object
	local selection = {
		name = theme.name,
		flavor = flavor,
		lualine_name = theme.lualine_name,
		setup_fn = theme.setup_fn,
	}

	-- Cache selection globally so all plugins use the same theme
	vim.g.current_theme_selection = selection

	return selection
end

-- Get the current theme selection without re-randomizing
-- This function is called by lualine to sync its theme
function M.get_current_theme()
	-- If no selection exists, trigger selection
	if not vim.g.current_theme_selection then
		return M.select_random_theme()
	end

	return vim.g.current_theme_selection
end

return M
