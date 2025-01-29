local config

local function select_notebook(client, name, cb)
	if not name then
		local picker = require("nb-nvim.picker")
		picker.notebook(client, function(choice)
			cb(choice)
		end)
		return
	end
end

return function(client, obj)
	local name = obj.fargs[1]
	select_notebook(client, name, function(val)
		client.config.playbook = val
	end)
end
