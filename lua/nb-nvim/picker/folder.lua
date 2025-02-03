local M = {}
local ui = require("nb-nvim.ui")

function M.folder(client, playbook, cb)
	local ok, folders = client.notebook.ListFolders(playbook)
	if ok == false then
		return
	end

	local filtered = {}
	for _, item in ipairs(folders) do
		if item ~= "" then
			table.insert(filtered, item)
		end
	end

	ui.pickone(filtered, "Choose folder", nil, function(selected)
		cb(selected)
	end)
end

return M
