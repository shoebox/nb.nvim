local M = {}
local exec = require("nb-nvim.client.execute")
local vim = vim

M.List = function()
	local exitCode
	local stdout
	local on_exit = function(obj)
		stdout = obj.stdout
		exitCode = obj.code
	end
	local cmd = exec.CreateCmd("notebooks", { "--no-color", "--name" })
	exec.ExecuteNbCommand(cmd, on_exit)
	if exitCode ~= 0 then
		return false, nil
	end

	local lines = vim.split(stdout, "\n")

	return exitCode == 0, lines
end

M.ListFolders = function(playbook)
	local args = { "--no-id", "--no-indicator", playbook .. ":" }

	local cmd = exec.CreateCmd("list", args)
	local ok, exitCode, stdout = exec.RunCommand(cmd)
	if ok == false then
		return false, nil
	end

	if exitCode == 0 then
		local lines = vim.split(stdout, "\n")
		return true, lines
	end

	return false, nil
end

return M
