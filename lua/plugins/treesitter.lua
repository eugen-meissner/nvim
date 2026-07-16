return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			-- Neovim nightly currently trips nvim-treesitter's markdown code-fence
			-- language directive in hover/markdown buffers. Keep inline markdown
			-- injections, but skip fenced code block injections.
			vim.treesitter.query.set(
				"markdown",
				"injections",
				[[([(inline) (pipe_table_cell)] @injection.content (#set! injection.language "markdown_inline"))]]
			)

			configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"query",
					"go",
					"gomod",
					"gowork",
					"gosum",
					"javascript",
					"html",
					"c_sharp",
					"terraform",
					"yaml",
					"tsx",
					"typescript",
					"json",
					"bash",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
