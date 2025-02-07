local client = require("nb-nvim.client")
local commands = require("nb-nvim.commands")
local journal = require("nb-nvim.journal")
local nb = setmetatable({}, { __index = journal })

nb.__index = function(table, key)
  if journal[key] then
    return journal[key]
  elseif commands[key] then
    return commands[key]
  else
    return nil -- or default behavior
  end
end

function nb.setup(opts)
  opts = opts or {}
  client.executor.debug = opts.debug

  commands.setup(client)
  journal.setup(client)
end

setmetatable(nb, nb) -- set M as its own metatable for indexing

return nb
