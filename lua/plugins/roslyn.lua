return {
	"seblj/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	ft = { "cs", "razor" },
	dependencies = {
		{
			-- rzls provides Razor/Blazor LSP support
			-- By loading as a dependency, we ensure handlers are available for Roslyn
			"tris203/rzls.nvim",
			config = true,
		},
	},
	lazy = false,
	opts = {
		-- Configuration options for roslyn.nvim
		-- You can add custom settings here if needed
	},
	config = function()
		-- Get Mason package paths
		local mason_registry = require("mason-registry")

		-- Path to rzls package in Mason
		local rzls_path = vim.fn.stdpath("data") .. "/mason/packages/rzls/libexec"

		-- Build the command to start Roslyn with Razor support
		local cmd = {
			"roslyn",
			"--stdio",
			"--logLevel=Information",
			"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
			"--razorDesignTimePath="
				.. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
			"--extension",
			vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
		}

		-- Configure Roslyn LSP
		vim.lsp.config("roslyn", {
			cmd = cmd,
			handlers = require("rzls.roslyn_handlers"),
			settings = {
				-- Inlay hints configuration
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
					csharp_enable_inlay_hints_for_types = true,
					dotnet_enable_inlay_hints_for_indexer_parameters = true,
					dotnet_enable_inlay_hints_for_literal_parameters = true,
					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
					dotnet_enable_inlay_hints_for_other_parameters = true,
					dotnet_enable_inlay_hints_for_parameters = true,
					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
				},
				-- Code lens configuration
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
			},
		})

		-- Enable the Roslyn LSP
		vim.lsp.enable("roslyn")
	end,
	init = function()
		-- Register Razor file types before the plugin loads
		vim.filetype.add({
			extension = {
				razor = "razor",
				cshtml = "razor",
			},
		})
	end,
}
