local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Move to right window" })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Harpoon

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>E", function()
	harpoon:list():add()
	vim.notify("File added to Harpoon", vim.log.levels.INFO, {
		title = "Harpoon",
		timeout = 2000,
	})
end, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>e", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })

-- Navigation keymaps
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon: Go to file 1" })
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon: Go to file 4" })

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- LSP
keymap(
	"n",
	"gD",
	"<cmd>lua vim.lsp.buf.declaration()<CR>",
	{ noremap = true, silent = true, desc = "LSP: Go to declaration" }
)
keymap(
	"n",
	"gd",
	"<cmd>lua vim.lsp.buf.definition()<CR>",
	{ noremap = true, silent = true, desc = "LSP: Go to definition" }
)
keymap(
	"n",
	"K",
	"<cmd>Lspsaga hover_doc<CR>",
	{ noremap = true, silent = true, desc = "LSP: Show hover documentation" }
)
keymap("n", "F", "<cmd>Lspsaga finder<CR>", { noremap = true, silent = true, desc = "LSP: Open symbol finder" })
keymap(
	"n",
	"gI",
	"<cmd>lua vim.lsp.buf.implementation()<CR>",
	{ noremap = true, silent = true, desc = "LSP: Go to implementation" }
)
keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", { noremap = true, silent = true, desc = "LSP: Find references" })
keymap(
	"n",
	"gl",
	"<cmd>lua vim.diagnostic.open_float()<CR>",
	{ noremap = true, silent = true, desc = "LSP: Show diagnostics in float window" }
)
keymap(
	"n",
	"<leader>lf",
	"<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
	{ noremap = true, silent = true, desc = "LSP: Format document" }
)
keymap("n", "<leader>li", "<cmd>LspInfo<cr>", { noremap = true, silent = true, desc = "LSP: Show LSP information" })
keymap(
	"n",
	"<leader>lj",
	"<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>",
	{ noremap = true, silent = true, desc = "LSP: Go to next diagnostic" }
)
keymap(
	"n",
	"<leader>lk",
	"<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>",
	{ noremap = true, silent = true, desc = "LSP: Go to previous diagnostic" }
)
keymap(
	"n",
	"<leader>lr",
	"<cmd>lua vim.lsp.buf.rename()<cr>",
	{ noremap = true, silent = true, desc = "LSP: Rename symbol" }
)
keymap(
	"n",
	"<leader>ls",
	"<cmd>lua vim.lsp.buf.signature_help()<CR>",
	{ noremap = true, silent = true, desc = "LSP: Show signature help" }
)
keymap(
	"n",
	"<leader>lq",
	"<cmd>lua vim.diagnostic.setloclist()<CR>",
	{ noremap = true, silent = true, desc = "LSP: Add diagnostics to location list" }
)

-- Debugging --
keymap("n", "<F8>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<F7>", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts)
keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<F3>", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<F4>", "<cmd>lua require'dapui'.eval(nil, { enter=true })<cr>", opts)
keymap("n", "<F10>", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<F9>", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<S-F9>", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap(
	"n",
	"<leader>du",
	"<cmd>lua require'dapui'.toggle()<cr>",
	{ noremap = true, silent = true, desc = "Debug: Toggle UI" }
)
keymap(
	"n",
	"<leader>q",
	"<cmd>lua require'dap'.terminate()<cr>",
	{ noremap = true, silent = true, desc = "Debug: Terminate session" }
)
keymap(
	"n",
	"<space>?",
	"<cmd>lua require'dapui'.eval(nil, { enter=true })<cr>",
	{ noremap = true, silent = true, desc = "Debug: Evaluate expression" }
)

-- NvimTree
keymap("n", "<C-n>", "<cmd> NvimTreeToggle <CR>", opts)

-- Trouble diagnostics
keymap(
	"n",
	"<leader>cw",
	"<cmd>Trouble diagnostics<cr>",
	{ noremap = true, silent = true, desc = "Trouble: Workspace Diagnostics" }
)
keymap(
	"n",
	"<leader>cl",
	"<cmd>Trouble loclist<cr>",
	{ noremap = true, silent = true, desc = "Trouble: Location List" }
)
