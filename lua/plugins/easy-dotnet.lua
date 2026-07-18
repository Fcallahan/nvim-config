return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	ft = "cs", -- Only load for C# files
	config = function()
		local dotnet = require("easy-dotnet")

		dotnet.setup({
			-- IMPORTANT: Disable the built-in LSP to avoid conflict with roslyn
			lsp = {
				enabled = false, -- Keep your existing roslyn LSP
			},

			-- Diagnostics configuration - show only build errors
			diagnostics = {
				default_severity = "error", -- Show only errors, not warnings
				setqflist = false, -- Use diagnostic API instead of quickfix
			},

			-- Test runner settings (basic features only, debugging handled by neotest-vstest)
			test_runner = {
				viewmode = "float", -- Options: "split", "vsplit", "float", "buf"
				auto_start_testrunner = false,
			},

			-- Picker integration (using telescope)
			picker = "telescope",

			-- Avoid starting the easy-dotnet server on first C# file open
			background_scanning = false,

			-- Auto-mappings for project files
			csproj_mappings = true,
			fsproj_mappings = true,

			-- Namespace auto-bootstrap
			auto_bootstrap_namespace = {
				enabled = true,
				type = "file_scoped", -- Modern C# style
			},
		})

		-- CUSTOM WRITE-AND-BUILD COMMAND (for when you want to see build output)
		vim.api.nvim_create_user_command("Wb", function()
			vim.cmd("write") -- Save current buffer
			require("easy-dotnet").build_default() -- Build with terminal output
		end, { desc = "Write and build with terminal output" })

		-- WRITE AND DEBUG BUILD (builds entire solution for debugging)
		vim.api.nvim_create_user_command("Wd", function()
			vim.cmd("write") -- Save current buffer
			-- Build entire solution (more reliable than build default)
			vim.cmd("Dotnet build solution")
		end, { desc = "Write and build solution (for debugging)" })

		-- KEYBINDINGS (following <leader>c pattern for code actions)
		local keymap = vim.keymap.set

		-- Build commands
		keymap("n", "<leader>cb", dotnet.build, { desc = "[C]# [B]uild project" })
		keymap("n", "<leader>cB", dotnet.build_solution, { desc = "[C]# [B]uild solution" })
		keymap("n", "<leader>cd", dotnet.build_default, { desc = "[C]# Build [d]efault/last" })

		-- Build with quickfix
		keymap("n", "<leader>cq", function()
			vim.cmd("Dotnet build quickfix")
		end, { desc = "[C]# Build to [q]uickfix" })

		-- Diagnostics
		keymap("n", "<leader>ce", function()
			vim.cmd("Dotnet diagnostic errors")
		end, { desc = "[C]# Show build [e]rrors" })

		keymap("n", "<leader>cw", function()
			vim.cmd("Dotnet diagnostic warnings")
		end, { desc = "[C]# Show build [w]arnings" })

		-- Run commands
		keymap("n", "<leader>cr", dotnet.run, { desc = "[C]# [R]un project" })
		keymap("n", "<leader>cR", dotnet.run_default, { desc = "[C]# [R]un default/last" })

		-- Test commands
		keymap("n", "<leader>ct", function()
			vim.cmd("Dotnet test")
		end, { desc = "[C]# Run [t]ests" })

		-- Project management
		keymap("n", "<leader>cO", function()
			vim.cmd("Dotnet outdated")
		end, { desc = "[C]# Check [O]utdated packages" })

		keymap("n", "<leader>cs", function()
			vim.cmd("Dotnet secrets")
		end, { desc = "[C]# Manage user [s]ecrets" })

		-- Write-and-Build keymap (verbose build with terminal output)
		keymap("n", "<leader>cW", function()
			vim.cmd("Wb")
		end, { desc = "[C]# [W]rite and build (verbose)" })
	end,
}
