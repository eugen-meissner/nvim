return {
	{
		"MagicDuck/grug-far.nvim",
		cmd = { "GrugFar", "GrugFarWithin" },
		keys = {
			{ "<leader>R", "<cmd>GrugFar<cr>", desc = "Search and replace" },
			{ "<leader>R", "<cmd>GrugFarWithin<cr>", mode = "x", desc = "Search and replace selection" },
		},
		opts = {},
	},
}
