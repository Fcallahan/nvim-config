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
			-- IMPORTANT: Disable the built-in LSP to avoid conflict with csharp_ls
			lsp = {
				enabled = false, -- Keep your existing csharp_ls LSP
			},

			-- Build configuration - ALWAYS use Debug for better debugging
			build_config = "Debug",

			-- Diagnostics configuration - show only build errors
			diagnostics = {
				default_severity = "error", -- Show only errors, not warnings
				setqflist = false, -- Use diagnostic API instead of quickfix
			},

			-- Test runner settings
			test_runner = {
				viewmode = "float", -- Options: "split", "vsplit", "float", "buf"
				noBuild = true, -- Skip build before testing (faster)
			},

			-- Picker integration (using telescope)
			picker = "telescope",

			-- Auto-mappings for project files
			csproj_mappings = true,
			fsproj_mappings = true,

			-- Namespace auto-bootstrap
			auto_bootstrap_namespace = {
				enabled = true,
				type = "file_scoped", -- Modern C# style
			},
		})

		-- SILENT AUTO-BUILD ON SAVE (no buffer opens unless there are errors)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.cs",
			callback = function()
				-- Schedule to avoid blocking and build entire solution (no picker needed)
				vim.schedule(function()
					require("easy-dotnet").build_solution_quickfix()
				end)
			end,
			desc = "Auto-build C# solution silently on save",
		})

		-- CUSTOM WRITE-AND-BUILD COMMAND (for when you want to see build output)
		vim.api.nvim_create_user_command("Wb", function()
			vim.cmd("write") -- Save current buffer
			require("easy-dotnet").build_default() -- Build with terminal output
		end, { desc = "Write and build with terminal output" })

		-- WRITE AND DEBUG BUILD (explicitly builds Debug configuration)
		vim.api.nvim_create_user_command("Wd", function()
			vim.cmd("write") -- Save current buffer
			-- Build Debug configuration explicitly (better for debugging)
			vim.cmd("Dotnet build default")
		end, { desc = "Write and build Debug (for debugging)" })

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
		keymap("n", "<leader>cp", function()
			vim.cmd("Dotnet outdated")
		end, { desc = "[C]# Check outdated [p]ackages" })

		keymap("n", "<leader>cs", function()
			vim.cmd("Dotnet secrets")
		end, { desc = "[C]# Manage user [s]ecrets" })

		-- Write-and-Build keymap (verbose build with terminal output)
		keymap("n", "<leader>cW", function()
			vim.cmd("Wb")
		end, { desc = "[C]# [W]rite and build (verbose)" })
	end,
}
