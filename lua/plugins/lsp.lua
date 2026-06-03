return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", opts = {} },
			"Hoffs/omnisharp-extended-lsp.nvim",
		},
		config = function()
			local mason_lspconf = require("mason-lspconfig")
			local disable_omnisharp_semantic_tokens = function(client)
				-- OmniSharp semantic tokens can drift in long-lived sessions and corrupt C# highlights.
				if client.name == "omnisharp" then
					client.server_capabilities.semanticTokensProvider = nil
				end
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", {
				capabilities = capabilities,
			})
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						completeUnimported = true,
						gofumpt = true,
						staticcheck = true,
						usePlaceholders = true,
					},
				},
			})
			vim.lsp.config("omnisharp", {
				capabilities = capabilities,
				on_attach = disable_omnisharp_semantic_tokens,
			})
			mason_lspconf.setup({
				ensure_installed = {},
				automatic_enable = {
					exclude = {
						"rust_analyzer",
					},
				},
			})
			vim.lsp.enable("gopls")
		end,
	},
}
