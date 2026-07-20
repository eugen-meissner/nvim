return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"citizenharris/neotest-dotnet",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({}),
					require("neotest-dotnet")({
						dap = {
							adapter_name = "coreclr",
						},
						discovery_root = "project",
					}),
				},
			})
		end,
	},
}
