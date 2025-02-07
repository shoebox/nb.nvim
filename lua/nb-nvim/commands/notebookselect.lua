local picker = require("nb-nvim.picker")

local M = {}
M.client = nil

function M.setup(client)
  M.client = client
end

function M.selectNotebook(name, cb)
  if not name then
    picker.notebook(M.client, function(choice)
      cb(choice)
    end)
    return
  end
end

function M.callback(obj)
  local name = obj.fargs[1]
  M.selectNotebook(name, function(val)
    M.client.config.playbook = val
  end)
end

return M
