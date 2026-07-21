local M = {}

M.default = "gruvbox"
M.state_path = vim.fn.stdpath("state") .. "/colorscheme"

M.names = {
	"cyberdream",
	"cyberdream-light",
	"gruvbox",
	"kanagawa",
	"kanagawa-dragon",
	"kanagawa-lotus",
	"kanagawa-wave",
	"miasma",
	"oxocarbon",
	"rose-pine",
	"rose-pine-dawn",
	"rose-pine-main",
	"rose-pine-moon",
	"solarized-osaka",
	"solarized-osaka-day",
}

local allowed = {}
for _, name in ipairs(M.names) do
	allowed[name] = true
end

function M.is_allowed(name)
	return type(name) == "string" and allowed[name] == true
end

function M.read()
	local ok, lines = pcall(vim.fn.readfile, M.state_path)
	local name = ok and lines[1] or nil
	return M.is_allowed(name) and name or M.default
end

function M.write(name)
	if not M.is_allowed(name) then
		vim.notify(("Unknown colorscheme: %s"):format(name), vim.log.levels.WARN)
		return false
	end

	vim.fn.mkdir(vim.fn.fnamemodify(M.state_path, ":h"), "p")
	local ok, result = pcall(vim.fn.writefile, { name }, M.state_path)
	if not ok or result ~= 0 then
		vim.notify("Failed to save colorscheme", vim.log.levels.ERROR)
		return false
	end

	return true
end

function M.apply(name, opts)
	opts = opts or {}
	if not M.is_allowed(name) then
		vim.notify(("Unknown colorscheme: %s"):format(name), vim.log.levels.WARN)
		return false
	end

	local ok = pcall(vim.cmd.colorscheme, name)
	if ok and opts.save ~= false then
		M.write(name)
	end

	return ok
end

function M.load()
	local name = M.read()
	if M.apply(name, { save = false }) then
		return name
	end

	if name ~= M.default and M.apply(M.default, { save = false }) then
		return M.default
	end
end

function M.items()
	local rtp = vim.o.runtimepath
	if package.loaded.lazy then
		rtp = rtp .. "," .. table.concat(require("lazy.core.util").get_unloaded_rtp(""), ",")
	end

	local files = {}
	for _, file in ipairs(vim.fn.globpath(rtp, "colors/*", false, true)) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		local ext = vim.fn.fnamemodify(file, ":e")
		if M.is_allowed(name) and (ext == "vim" or ext == "lua") then
			files[name] = files[name] or file
		end
	end

	return vim.tbl_map(function(name)
		return {
			text = name,
			file = files[name],
		}
	end, vim.tbl_filter(function(name)
		return files[name] ~= nil
	end, M.names))
end

return M
