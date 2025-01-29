local client = require("nb-nvim.client")
local journal = require("nb-nvim.journal")
local notebooks = require("nb-nvim.notebooks")
local commands = require("nb-nvim.commands")

local nb = setmetatable({}, { __index = journal })

nb.__index = function(table, key)
	if journal[key] then
		return journal[key]
	elseif notebooks[key] then
		return notebooks[key]
	elseif commands[key] then
		return commands[key]
	else
		return nil -- or default behavior
	end
end

function nb.setup(opts)
	opts = opts or {}
	commands.install(client)
end

setmetatable(nb, nb) -- set M as its own metatable for indexing

return nb
