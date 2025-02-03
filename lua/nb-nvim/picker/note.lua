local M = {}
local ui = require("nb-nvim.ui")

function M.notes(client, playbook, folder, cb)
	local ok, notes = client.note.List(playbook, folder)
	if not ok then
		return false
	end
	ui.pickone(notes, "Choose note", nil, function(selected)
		cb(selected)
	end)

	return true
end

function M.pickNoteName()
	local name = ui.prompt("Enter note title: ", {})
	if not name then
		vim.notify("No note name provided", vim.log.levels.ERROR)
		return false, ""
	end

	return true, name
end

return M
