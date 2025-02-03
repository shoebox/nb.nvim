local ui = require("nb-nvim.ui")
local picker = require("nb-nvim.picker")
local vim = vim
local M = {}
M.client = nil

function M.setup(client)
	M.client = client
end

function M.create_note(playbook, folder, name, defaultContent)
	if not name then
		name = ui.prompt("Enter note title: ", {})
	end
	if name == nil then
		return
	end

	local notePath = M.client.note.GetPath(playbook, folder, name)

	-- checking if note already exists
	local exists = M.client.note.Exists(notePath)
	if exists then
		vim.notify("Note already at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	-- adds note to playbook
	local ok = M.client.note.Add(notePath, defaultContent)
	if ok == false then
		vim.notify("Failed to add note at path: " .. notePath, vim.log.levels.ERROR)
		return false
	end

	return M.client.note.Open(notePath)
end

function M.callback(obj)
	local playbook = M.client.config.playbook
	local folder = obj.fargs[1]
	local name = obj.fargs[2]

	if not folder then
		picker.folder(M.client, playbook, function(choice)
			M.create_note(playbook, choice, name, "empty")
		end)
	else
		M.create_note(playbook, folder, name, "empty")
	end
end

return M
