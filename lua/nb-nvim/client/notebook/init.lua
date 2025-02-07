local modules = {
  list = require("nb-nvim.client.notebook.list"),
}

local mt = {
  __index = function(_, key)
    for _, module in pairs(modules) do
      if module[key] then
        return module[key]
      end
    end
    return nil
  end,
}

local M = setmetatable({}, mt)

return M
