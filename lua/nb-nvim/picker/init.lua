local folder = require("nb-nvim.picker.folder")
local note = require("nb-nvim.picker.note")
local notebook = require("nb-nvim.picker.notebook")

local mt = {
	__index = function(_, key)
		if folder[key] then
			return folder[key]
		elseif note[key] then
			return note[key]
		elseif notebook[key] then
			return notebook[key]
		else
			return nil
		end
	end,
}

local pickers = setmetatable({}, mt)

return pickers
