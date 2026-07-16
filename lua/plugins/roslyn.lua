return {
	{
		"seblyng/roslyn.nvim",
		url = "https://github.com/seblyng/roslyn.nvim.git",
		ft = { "cs", "cshtml", "razor" },
		dependencies = {
			"saghen/blink.cmp",
		},
		---@module "roslyn.config"
		---@type RoslynNvimConfig
		opts = {
			filewatching = "roslyn",
			broad_search = true,
		},
		config = function(_, opts)
			local command = vim.fn.exepath("roslyn-language-server")
			if command == "" then
				command = vim.fn.exepath("Microsoft.CodeAnalysis.LanguageServer")
			end

			if command == "" then
				vim.notify("Roslyn language server is not available on PATH", vim.log.levels.WARN, {
					title = "roslyn.nvim",
				})
				return
			end

			vim.lsp.config("roslyn", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				cmd = {
					command,
					"--logLevel",
					"Information",
					"--extensionLogDirectory",
					vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn.nvim", "logs"),
					"--stdio",
				},
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
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
					["csharp|formatting"] = {
						dotnet_organize_imports_on_format = true,
					},
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
				},
			})

			require("roslyn").setup(opts)
		end,
	},
}
