local M = {}

local function notify(message, level)
	vim.schedule(function()
		vim.notify(message, level or vim.log.levels.INFO, { title = ".NET Debug" })
	end)
end

local function run_process(command, args, cwd)
	local nio = require("nio")
	local process, err = nio.process.run({
		cmd = command,
		args = args,
		cwd = cwd,
	})
	if not process then
		return nil, "", err
	end

	local results = nio.gather({
		process.stdout.read,
		process.stderr.read,
		function()
			return process.result()
		end,
	})
	process.close()

	return results[3], results[1] or "", results[2] or ""
end

local function fallback_to_neotest()
	require("neotest").run.run({ strategy = "dap" })
end

function M.debug_nearest()
	if vim.bo.filetype ~= "cs" then
		fallback_to_neotest()
		return
	end

	require("nio").run(function()
		local neotest = require("neotest")
		local tree = neotest.run.get_tree_from_args()
		if not tree then
			notify("No test found at the cursor", vim.log.levels.WARN)
			return
		end

		local position = tree:data()
		if position.type ~= "test" then
			notify("Place the cursor inside the test you want to debug", vim.log.levels.WARN)
			return
		end

		local lib = require("neotest.lib")
		local project_root = lib.files.match_root_pattern("*.csproj")(position.path)
		if not project_root then
			notify("Could not find a .csproj for this test", vim.log.levels.ERROR)
			return
		end

		local project_files = vim.fs.find(function(name)
			return name:match("%.csproj$") ~= nil
		end, {
			path = project_root,
			type = "file",
			limit = 1,
		})
		local project_file = project_files[1]
		if not project_file then
			notify("Could not find a .csproj in " .. project_root, vim.log.levels.ERROR)
			return
		end

		local build_code, build_stdout, build_stderr =
			run_process("dotnet", { "build", project_file, "--nologo" }, project_root)
		if build_code ~= 0 then
			notify("Build failed:\n" .. (build_stderr ~= "" and build_stderr or build_stdout), vim.log.levels.ERROR)
			return
		end

		local property_code, property_stdout, property_stderr = run_process("dotnet", {
			"msbuild",
			project_file,
			"-nologo",
			"-getProperty:TargetPath",
			"-getProperty:OutputType",
		}, project_root)
		if property_code ~= 0 then
			notify(
				"Could not resolve test executable:\n" .. (property_stderr ~= "" and property_stderr or property_stdout),
				vim.log.levels.ERROR
			)
			return
		end

		local ok, result = pcall(vim.json.decode, property_stdout)
		local properties = ok and result.Properties or nil
		if not properties or not properties.TargetPath then
			notify("Could not read TargetPath from MSBuild", vim.log.levels.ERROR)
			return
		end

		-- Exercism's xUnit v3 projects are standalone test executables. Launching
		-- them directly avoids netcoredbg's attach-mode Just My Code limitation.
		if properties.OutputType ~= "Exe" then
			notify("Using the standard test-host debugger for this project")
			fallback_to_neotest()
			return
		end

		local test_name = require("neotest-dotnet.utils.neotest-node-tree-utils")
			.get_qualified_test_name_from_id(position.running_id or position.id)
			:gsub("%b()", "")

		require("nio").scheduler()
		require("dap").run({
			type = "coreclr",
			request = "launch",
			name = "Debug nearest xUnit test",
			program = properties.TargetPath,
			args = { "-method", "*" .. test_name, "-noLogo" },
			cwd = project_root,
			justMyCode = false,
			stopAtEntry = false,
		})
	end, function(success, err)
		if not success then
			notify(tostring(err), vim.log.levels.ERROR)
		end
	end)
end

return M
