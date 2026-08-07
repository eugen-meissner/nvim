return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			{
				"leoluz/nvim-dap-go",
				config = function()
					require("dap-go").setup()
				end,
			},
			{
				"stevearc/overseer.nvim",
				opts = {},
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			local alacritty = vim.fn.exepath("alacritty")
			if alacritty ~= "" then
				dap.defaults.fallback.external_terminal = {
					command = alacritty,
					args = { "-e" },
				}
			end

			-- LLDB
			dap.adapters.lldb = {
				type = "executable",
				command = "codelldb",
				name = "lldb",
			}
			-- Setup the dotnet debugger
			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}
			dap.adapters.netcoredbg = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}
			-- Customize the dap ui
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
				layouts = {
					{
						elements = {
							-- Elements can be strings or table with id and size keys.
							{ id = "scopes", size = 0.25 },
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 60, -- 60 columns
						position = "left",
					},
					{
						elements = {
							"repl",
						},
						size = 0.25, -- 25% of total lines
						position = "bottom",
					},
				},
				floating = {
					max_height = nil, -- These can be integers or nil.
					max_width = nil, -- Integers if greater than 1, float if less than 1
					border = "single", -- Border style. Can be "single", "double" or "rounded"
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
				render = {
					max_type_length = nil, -- Can be integer or nil.
					max_value_lines = 100, -- Can be integer or nil.
				},
			})
			-- Register listeners
			local notified_exit = false
			dap.listeners.after.event_initialized["dapui_config"] = function()
				notified_exit = false
				dapui.open()
			end
			local function notify_exit(_, body)
				if notified_exit or not body or body.exitCode == nil then
					return
				end
				notified_exit = true
				local level = body.exitCode == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
				vim.notify(("Debug session exited with code %d"):format(body.exitCode), level, { title = "DAP" })
			end
			local function close_session(_, body)
				dapui.close()
				notify_exit(nil, body or { exitCode = nil })
			end
			dap.listeners.before.event_exited["dapui_config"] = notify_exit
			dap.listeners.before.event_terminated["dapui_config"] = close_session
			local overseer = require("overseer")
			overseer.setup({
				task_list = {
					direction = "bottom",
					min_height = 25,
					max_height = 25,
					default_detail = 1,
				},
				form = {
					border = "rounded",
					zindex = 40,
					min_width = 80,
					max_width = 0.9,
					width = nil,
					min_height = 10,
					max_height = 0.9,
					height = nil,
					win_opts = {
						winblend = 10,
					},
				},
				confirm = {
					border = "rounded",
					zindex = 40,
					min_width = 80,
					width = nil,
					max_width = 0.5,
					min_height = 10,
					height = nil,
					max_height = 0.9,
					win_opts = {
						winblend = 10,
					},
				},
				task_win = {
					padding = 1,
					border = "rounded",
					win_opts = {
						winblend = 10,
					},
				},
			})
			local dap_vscode = require("dap.ext.vscode")
			dap_vscode.json_decode = require("overseer.json").decode
			dap_vscode.type_to_filetypes = vim.tbl_extend("force", dap_vscode.type_to_filetypes or {}, {
				codelldb = { "rust" },
				lldb = { "rust" },
				coreclr = { "cs" },
				dotnet = { "cs" },
				netcoredbg = { "cs" },
			})

			local function show_build_progress()
				vim.cmd("OverseerOpen!")
			end

			local function hide_build_progress()
				vim.cmd("OverseerClose")
			end

			dap.listeners.before.event_initialized["build_feedback"] = function()
				hide_build_progress()
			end
			dap.listeners.before.event_terminated["build_feedback"] = hide_build_progress
			dap.listeners.before.event_exited["build_feedback"] = hide_build_progress
			dap.listeners.before.disconnect["build_feedback"] = hide_build_progress

			local original_run = dap.run
			dap.run = function(config, opts)
				if config and config.preLaunchTask then
					show_build_progress()
				end
				original_run(config, opts)
			end
			dap.listeners.before.disconnect["dapui_config"] = dapui.close
		end,
	},
}
