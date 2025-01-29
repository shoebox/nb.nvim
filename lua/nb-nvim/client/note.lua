local M = {}
local editor = require("nb-nvim.editor.editor")
local exec = require("nb-nvim.client.execute")
local vim = vim

M.Add = function(path, content)
	if not content then
		content = "empty"
	end

	local args = { path, "--content", content }
	local cmd = exec.CreateCmd("add", args)
	local ok, _, _ = exec.RunCommand(cmd)

	if ok == 0 then
		vim.notify("Note added successfully")
	end

	return ok
end

M.List = function(playbook, folder)
	local args = { "--no-id", "--filenames", "-t", "note", playbook .. ":" .. folder .. "/" }
	local cmd = exec.CreateCmd("list", args)

	--
	local exitCode
	local stdout
	local on_exit = function(obj)
		stdout = obj.stdout
		exitCode = obj.code
	end

	exec.ExecuteNbCommand(cmd, on_exit)

	return exitCode == 0, vim.split(stdout, "\n")
end

M.GetPath = function(playbook, folder, filename)
	return string.format("%s:%s/%s", playbook, folder, filename)
end

M.Edit = function(notePath, content)
	local args = exec.CreateCmd("edit", {
		notePath,
		"--overwrite",
	})

	local exitCode = exec.ExecuteNbCommand(args, nil, content)
	return exitCode == 0
end

M.Open = function(notePath)
	local ok, lines = M.Show(notePath)
	if not ok then
		vim.notify("failed to open note", vim.log.levels.ERROR)
		return false
	end

	local bufferID = editor.CreateTempBuffer()
	vim.api.nvim_buf_set_lines(bufferID, 0, -1, false, lines)
	vim.bo[bufferID].modified = false

	editor.BufWritePostAutocmd(function()
		local content = editor.GetBufferLines(bufferID)
		M.Edit(notePath, content)
	end, bufferID)

	return true
end

M.Exists = function(path)
	local cmd = exec.CreateCmd("list", { "--no-color", path })

	local res = exec.ExecuteNbCommand(cmd)
	return res == 0
end

M.Show = function(notePath)
	local args = { "--print", notePath, "--no-color" }
	local cmd = exec.CreateCmd("show", args)

	local exitCode
	local stdout
	local on_exit = function(obj)
		stdout = obj.stdout
		exitCode = obj.code
	end
	exec.ExecuteNbCommand(cmd, on_exit)

	local lines = vim.split(stdout, "\n")

	return exitCode == 0, lines
end

return M
