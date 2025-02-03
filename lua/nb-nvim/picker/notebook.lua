local ui = require("nb-nvim.ui")
local M = {}

function M.notebook(client, cb)
	local ok, list = client.notebook.List()
	if ok == false then
		return
	end

	local filtered = {}
	for _, item in ipairs(list) do
		if item ~= "" then
			table.insert(filtered, item)
		end
	end

	ui.pickone(filtered, "Choose notebook", nil, function(selected)
		cb(selected)
	end)
end

return M
