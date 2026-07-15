return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", opts = {} },
			"Hoffs/omnisharp-extended-lsp.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function executable(command)
				return vim.fn.executable(command) == 1
			end

			local function disable_omnisharp_semantic_tokens(client)
				-- OmniSharp semantic tokens can drift in long-lived sessions and corrupt C# highlights.
				if client.name == "omnisharp" then
					client.server_capabilities.semanticTokensProvider = nil
				end
			end

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

			local lsp_servers = {
				{ "eslint", "vscode-eslint-language-server" },
				{ "gopls", "gopls" },
				{ "lua_ls", "lua-language-server" },
				{ "tailwindcss", "tailwindcss-language-server" },
				{ "terraformls", "terraform-ls" },
				{ "texlab", "texlab" },
				{ "ts_ls", "typescript-language-server" },
			}

			for _, server in ipairs(lsp_servers) do
				if executable(server[2]) then
					vim.lsp.enable(server[1])
				end
			end

			local roslyn = executable("roslyn-language-server") and "roslyn-language-server"
				or executable("Microsoft.CodeAnalysis.LanguageServer") and "Microsoft.CodeAnalysis.LanguageServer"
				or nil

			if roslyn then
				vim.lsp.config("roslyn_ls", {
					capabilities = capabilities,
					cmd = {
						roslyn,
						"--logLevel",
						"Information",
						"--extensionLogDirectory",
						vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls", "logs"),
						"--stdio",
					},
				})
				vim.lsp.enable("roslyn_ls")
				return
			end

			local omnisharp = executable("OmniSharp") and "OmniSharp" or executable("omnisharp") and "omnisharp" or nil

			if omnisharp then
				vim.lsp.config("omnisharp", {
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						workspace = {
							workspaceFolders = false,
						},
					}),
					cmd = {
						omnisharp,
						"-z",
						"--hostPID",
						tostring(vim.fn.getpid()),
						"DotNet:enablePackageRestore=false",
						"--encoding",
						"utf-8",
						"--languageserver",
					},
					on_attach = disable_omnisharp_semantic_tokens,
				})
				vim.lsp.enable("omnisharp")
			end
		end,
	},
}
