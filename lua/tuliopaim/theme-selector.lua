local M = {}

-- Theme registry with all available themes and their variants
-- Commented out because I want to just use tokyonight moon
-- M.themes = {
-- 	{
-- 		name = "catppuccin",
-- 		flavors = { "frappe", "macchiato", "mocha" },
-- 		lualine_name = "catppuccin",
-- 	},
-- 	{
-- 		name = "tokyonight",
-- 		flavors = { "night", "storm", "moon" },
-- 		lualine_name = "tokyonight",
-- 	},
-- 	-- {
-- 	-- 	name = "gruvbox",
-- 	-- 	flavors = { "dark", "light" },
-- 	-- 	lualine_name = "gruvbox",
-- 	-- 	setup_fn = function(flavor)
-- 	-- 		vim.o.background = flavor
-- 	-- 	end,
-- 	-- },
-- 	-- {
-- 	-- 	name = "kanagawa",
-- 	-- 	flavors = { "wave", "dragon", "lotus" },
-- 	-- 	lualine_name = "kanagawa",
-- 	-- },
-- 	{
-- 		name = "nightfox",
-- 		flavors = { "nightfox", "duskfox", "nordfox", "terafox", "carbonfox" },
-- 		lualine_name = "nightfox",
-- 	},
-- }
M.themes = {
	{
		name = "tokyonight",
		flavors = { "moon" },
		lualine_name = "tokyonight",
	},
	-- {
	-- 	name = "gruvbox",
	-- 	flavors = { "dark", "light" },
	-- 	lualine_name = "gruvbox",
	-- 	setup_fn = function(flavor)
	-- 		vim.o.background = flavor
	-- 	end,
	-- },
	-- {
	-- 	name = "kanagawa",
	-- 	flavors = { "wave", "dragon", "lotus" },
	-- 	lualine_name = "kanagawa",
	-- },
}

-- Select a random theme from the registry
-- This function is called by theme plugins during startup
-- Returns cached selection if already chosen (prevents re-randomization)
function M.select_random_theme()
	-- Return cached selection if it already exists
	if vim.g.current_theme_selection then
		return vim.g.current_theme_selection
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
