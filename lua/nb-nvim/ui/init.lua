local prompt = require("nb-nvim.ui.prompt")
local select = require("nb-nvim.ui.select")

local mt = {
	__index = function(_, key)
		if prompt[key] then
			return prompt[key]
		elseif select[key] then
			return select[key]
		else
			return nil
		end
	end,
}

local ui = setmetatable({}, mt)

return ui
