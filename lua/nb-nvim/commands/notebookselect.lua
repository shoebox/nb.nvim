local function select_notebook(client, name)
	if not name then
		local picker = require("nb-nvim.picker")
		picker.notebook(client, function(choice)
			print("choice", choice)
		end)
		return
	end
end

return function(client, obj)
	local name = obj.fargs[1]
	select_notebook(client, name)
end
