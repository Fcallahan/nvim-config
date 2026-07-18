return {
    {
		"zbirenbaum/copilot.lua",
        command = "Copilot",
        enabled = true,
		event = { "BufEnter", "InsertEnter" },
		config = function()
			require("copilot").setup({
                enabled = true,
                auto_refresh = true,
				suggestion = {
					enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = "<M-Right>",  -- Alt+Right to accept word by word
                        accept_line = "<M-End>",    -- Alt+End to accept line by line
                        next = "<M-]>",              -- Alt+] for next suggestion
                        prev = "<M-[>",              -- Alt+[ for previous suggestion
                        dismiss = "<C-]>",           -- Ctrl+] to dismiss
                    }
				},
                copilot_model = "gpt-41-copilot",
				panel = { enabled = false },
				filetypes = {
					["*"] = true,  -- Enable for all file types
				},
                server_opts_overrides = {
                    settings = {
                        advanced = {
                            listCount = 10,           -- Request more suggestions
                            length = 10000,           -- Longer completions
                            inlineSuggestCount = 3,   -- Show multiple alternatives
                        }
                    }
                }
			})
		end,
	}
}
