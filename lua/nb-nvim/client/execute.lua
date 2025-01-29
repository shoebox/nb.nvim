local vim = vim
local M = {}

M.PlaybookCmd = function(playbook, cmd)
	return { "nb", "--no-color", playbook .. ":" .. cmd }
end

M.BaseCmd = function(cmd)
	return { "nb", "--no-color", cmd }
end

M.CreatePlaybookCmd = function(playbook, cmd, args)
	local raw = vim.list_extend(M.PlaybookCmd(playbook, cmd), args)
	return raw
end

M.ExecuteNbCommand = function(command, on_exit, stdin)
	local exit_code = nil
	vim.system(command, { text = true, stdin = stdin or nil }, function(obj)
		exit_code = obj.code
		if on_exit then
			on_exit(obj)
		end
	end):wait()

	return exit_code
end

M.RunCommand = function(cmd)
	local exitCode
	local stdout
	local on_exit = function(obj)
		stdout = obj.stdout
		exitCode = obj.code
	end
	M.ExecuteNbCommand(cmd, on_exit)

	return exitCode == 0, exitCode, stdout
end

M.CreateCmd = function(cmd, args)
	return vim.list_extend(M.BaseCmdRaw(cmd), args)
end

M.BaseCmdRaw = function(cmd)
	return { "nb", cmd }
end

return M
