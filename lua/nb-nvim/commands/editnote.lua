local vim = vim
local ui = require("nb-nvim.ui")
local picker = require("nb-nvim.picker")

local function openNote(client, playbook, folder, name)
	local notePath = client.note.GetPath(playbook, folder, name)

	local exists = client.note.Exists(notePath)
	if exists == false then
		vim.notify("Note do not exists at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	return client.note.Open(notePath)
end

local function pickFolder(client, playbook, folder, cb)
	if not folder then
		picker.folder(client, playbook, function(choice)
			cb(choice)
		end)
	else
		cb(folder)
	end
end

local function pickNote(client, playbook, folder, name, cb)
	if not name then
		picker.notes(client, playbook, folder, function(choice)
			cb(choice)
		end)
	else
		cb(name)
	end
end

return function(client, obj)
	local playbook = client.config.playbook
	local folder = obj.fargs[1]
	local noteName = obj.fargs[2]

	pickFolder(client, playbook, folder, function(selectedFolder)
		pickNote(client, playbook, selectedFolder, noteName, function(filename)
			openNote(client, playbook, selectedFolder, filename)
		end)
	end)
end
