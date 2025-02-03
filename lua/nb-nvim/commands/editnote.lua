local vim = vim
local picker = require("nb-nvim.picker")

local M = {}
M.client = nil

function M.setup(client)
	M.client = client
end

function M.openNote(playbook, folder, name)
	local notePath = M.client.note.GetPath(playbook, folder, name)

	local exists = M.client.note.Exists(notePath)
	if exists == false then
		vim.notify("Note do not exists at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	return M.client.note.Open(notePath)
end

function M.pickFolder(playbook, folder, cb)
	if not folder then
		picker.folder(M.client, playbook, function(choice)
			cb(choice)
		end)
	else
		cb(folder)
	end
end

function M.pickNote(playbook, folder, name, cb)
	if not name then
		picker.notes(M.client, playbook, folder, function(choice)
			cb(choice)
		end)
	else
		cb(name)
	end
end

function M.callback(obj)
	local playbook = M.client.config.playbook
	local folder = obj.fargs[1]
	local noteName = obj.fargs[2]

	M.pickFolder(playbook, folder, function(selectedFolder)
		M.pickNote(playbook, selectedFolder, noteName, function(filename)
			M.openNote(playbook, selectedFolder, filename)
		end)
	end)
end

return M
