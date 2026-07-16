return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = {
		provider = "claude",
		anthropic = {
			endpoint = "https://api.anthropic.com/v1",
			model = "claude-opus-4-5-20251101", -- Other options: "claude-3-sonnet-20240229", "claude-3-haiku-20240307"
			timeout = 30000, -- Timeout in milliseconds (30 seconds)
			temperature = 0, -- Deterministic output
			max_completion_tokens = 4096, -- Max tokens to generate (adjust if needed, Anthropic caps at 4096 for some models)
		},
		selector = {
			provider = "snacks",
		},
		input = {
			provider = "snacks",
		},
	},
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"folke/snacks.nvim",
		"echasnovski/mini.icons",
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
