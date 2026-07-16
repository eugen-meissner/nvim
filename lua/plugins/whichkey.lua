return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"echasnovski/mini.icons",
		},
		config = function()
			local wk = require("which-key")

			wk.setup({
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = true,
						suggestions = 20,
					},
					presets = {
						operators = false,
						--motions = true,
						--text_objects = true,
						--windows = true,
						--nav = true,
						--z = true,
						--g = true,
					},
				},
				layout = {
					height = { min = 4, max = 25 },
					triggers_blacklist = {
						i = { "j", "k" }, -- Disable in insert mode
						v = { "j", "k" }, -- Disable in visual mode
					},
					width = { min = 20, max = 50 },
					spacing = 3,
					align = "left",
				},
				show_help = true,
				show_keys = false,
				triggers = { "<leader>", "<space>" },
				timeout = 10,
				disable = {
					buftypes = {},
					filetypes = {},
				},
			})

			-- Normal mode mappings
			wk.add({
				{ "<leader>n", "<cmd>enew<cr>", desc = "New File" },

				{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },

				{ "<leader>g", "<cmd>Neogit<cr>", desc = "Status" },

				{
					"<leader>x",
					function()
						Snacks.bufdelete()
					end,
					desc = "Delete Buffer",
				},
				{ "<leader>o", "<cmd>%bd|e#<cr>", desc = "Close Other Buffers" },

				{ "<leader>c", group = "code" },
				{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },

				{ "<leader>s", group = "search" },

				{ "<leader>r", group = "test" },
				{ "<leader>rr", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run nearest test" },
				{
					"<leader>rd",
					"<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
					desc = "Debug nearest test",
				},
				{
					"<leader>ra",
					"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
					desc = "Run tests in file",
				},
				{ "<leader>rs", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Test Summary" },
				{ "<leader>ro", "<cmd>lua require('neotest').output_panel.toggle()<CR>", desc = "Test Output" },

				{ "<leader>u", group = "ui" },
				{ "<leader>w", group = "window" },
				{ "<leader>wD", "<C-w>o", desc = "Close Others" },
				{ "<leader>wd", "<C-w>c", desc = "Close Window" },
				{ "<leader>wh", "<C-w>s", desc = "Horizontal Split" },
				{ "<leader>wm", "<C-w>_", desc = "Maximize Window" },
				{ "<leader>wr", "<C-w>r", desc = "Rotate Windows" },
				{ "<leader>wv", "<C-w>v", desc = "Vertical Split" },
			})
		end,
	},
	{
		"echasnovski/mini.icons",
		opts = {},
	},
}
