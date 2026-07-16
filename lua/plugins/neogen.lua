return {
	{
		"danymat/neogen",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = "Neogen",
		keys = {
			{
				"<leader>cd",
				function()
					require("neogen").generate()
				end,
				desc = "Generate docs",
			},
			{
				"<leader>cD",
				function()
					require("neogen").generate({ type = "file" })
				end,
				desc = "Generate file docs",
			},
			{
				"<leader>cC",
				function()
					require("neogen").generate({ type = "class" })
				end,
				desc = "Generate class docs",
			},
		},
		opts = {
			snippet_engine = "nvim",
			languages = {
				cs = {
					template = {
						annotation_convention = "xmldoc",
					},
				},
			},
		},
	},
}
