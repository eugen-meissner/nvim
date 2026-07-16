return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"saghen/blink.cmp",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local function executable(command)
				return vim.fn.executable(command) == 1
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
		end,
	},
}
