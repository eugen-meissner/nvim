return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = {
		provider = "deepseek",
		providers = {
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com",
				model = "deepseek-v4-flash",
				context_window = 1000000,
				extra_request_body = {
					thinking = { type = "enabled" },
					max_tokens = 16384,
				},
			},
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
