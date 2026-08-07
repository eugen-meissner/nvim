local colorscheme = require("config.colorscheme")

local picker_exclude = {
	"**/.cache/**",
	"**/.direnv/**",
	"**/.git/**",
	"**/.gradle/**",
	"**/.local/**",
	"**/.mypy_cache/**",
	"**/.next/**",
	"**/.nuxt/**",
	"**/.pytest_cache/**",
	"**/.ruff_cache/**",
	"**/.svelte-kit/**",
	"**/.turbo/**",
	"**/.venv/**",
	"**/.vite/**",
	"**/__pycache__/**",
	"**/bin/**",
	"**/build/**",
	"**/coverage/**",
	"**/dist/**",
	"**/node_modules/**",
	"**/obj/**",
	"**/out/**",
	"**/target/**",
	"**/vendor/**",
	"**/venv/**",
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			sections = {
				{
					pane = 1,
					{ title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "keys", gap = 1, padding = 10 },
					{ section = "startup" },
				},
			},
		},
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				files = {
					exclude = picker_exclude,
				},
				grep = {
					exclude = picker_exclude,
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<C-n>",
			function()
				Snacks.explorer.open()
			end,
			desc = "File explorer",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart find files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>f",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>F",
			function()
				Snacks.picker.grep()
			end,
			desc = "Find text",
		},
		{
			"<leader>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Switch buffer",
		},
		{
			"<leader>p",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent files",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find config file",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help pages",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location list",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix list",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume picker",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP workspace symbols",
		},
		{
			"<leader>uC",
			function()
				Snacks.picker.colorschemes({
					finder = colorscheme.items,
					confirm = function(picker, item)
						picker:close()
						if item then
							picker.preview.state.colorscheme = nil
							vim.schedule(function()
								colorscheme.apply(item.text)
							end)
						end
					end,
				})
			end,
			desc = "Colorschemes",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss notifications",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Go to definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Go to declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Go to implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Go to type definition",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next reference",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Previous reference",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				require("snacks.picker")
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
			end,
		})
	end,
}
