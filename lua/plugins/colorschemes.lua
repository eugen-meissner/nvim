return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("solarized-osaka").setup({
				transparent = true,
			})
			-- vim.cmd.colorscheme("solarized-osaka")
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				-- contrast = "hard",
				transparent_mode = true,
			})
			require("config.colorscheme").load()
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent = true,
			})
		end,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		priority = 1000,
	},
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function() end,
	},
	{
		"xero/miasma.nvim",
		lazy = false,
		priority = 1000,
		config = function() end,
	},
	{
		"ReallySnazzy/osaka-jade-nvim",
		lazy = false,
		priority = 1000,
	},
}
