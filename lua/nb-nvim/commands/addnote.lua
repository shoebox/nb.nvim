local ui = require("nb-nvim.ui")
local vim = vim

local function create_note(client, playbook, folder, name, defaultContent)
	if not name then
		name = ui.prompt("Enter note title: ", {})
	end
	if name == nil then
		return
	end

	local notePath = client.note.GetPath(playbook, folder, name)

	-- checking if note already exists
	local exists = client.note.Exists(notePath)
	if exists then
		vim.notify("Note already at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	-- adds note to playbook
	local ok = client.note.Add(notePath, defaultContent)
	if ok == false then
		vim.notify("Failed to add note at path: " .. notePath, vim.log.levels.ERROR)
		return false
	end

	return client.note.Open(notePath)
end

return function(client, obj)
	local playbook = client.config.playbook
	local folder = obj.fargs[1]
	local name = obj.fargs[2]
	if not folder then
		local picker = require("nb-nvim.picker")
		picker.folder(client, playbook, function(choice)
			create_note(client, playbook, choice, name, "empty")
		end)
	else
		create_note(client, playbook, folder, name, "empty")
	end
end
