return {
    "seblj/roslyn.nvim",
    ft = "cs",
    lazy = false,
    opts = {
        -- WSL-friendly: disable file watching for better performance
        filewatching = "off",
        -- Search for solution files in child directories
        broad_search = true,
        -- Lock solution target after first attach
        lock_target = true,
    },
    config = function(_, opts)
        -- Configure ONLY LSP settings via vim.lsp.config
        -- Let roslyn.nvim handle cmd and LSP initialization to prevent duplicate attachments
        vim.lsp.config("roslyn", {
            settings = {
                -- Inlay hints disabled to prevent crashes from invalid column positions
                ["csharp|inlay_hints"] = {
                    csharp_enable_inlay_hints_for_implicit_object_creation = false,
                    csharp_enable_inlay_hints_for_implicit_variable_types = false,
                    csharp_enable_inlay_hints_for_lambda_parameter_types = false,
                    csharp_enable_inlay_hints_for_types = false,
                    dotnet_enable_inlay_hints_for_indexer_parameters = false,
                    dotnet_enable_inlay_hints_for_literal_parameters = false,
                    dotnet_enable_inlay_hints_for_object_creation_parameters = false,
                    dotnet_enable_inlay_hints_for_other_parameters = false,
                    dotnet_enable_inlay_hints_for_parameters = false,
                    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
                },
                ["csharp|code_lens"] = {
                    dotnet_enable_references_code_lens = true,
                    dotnet_enable_tests_code_lens = true,
                },
                ["csharp|completion"] = {
                    dotnet_provide_regex_completions = true,
                    dotnet_show_completion_items_from_unimported_namespaces = true,
                    dotnet_show_name_completion_suggestions = true,
                },
                ["csharp|background_analysis"] = {
                    dotnet_analyzer_diagnostics_scope = "fullSolution",
                    dotnet_compiler_diagnostics_scope = "fullSolution",
                },
            },
        })

        -- Setup the roslyn.nvim plugin
        require("roslyn").setup(opts)
    end,
}
