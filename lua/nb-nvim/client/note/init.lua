local modules = {
  add = require("nb-nvim.client.note.add"),
  edit = require("nb-nvim.client.note.edit"),
  exists = require("nb-nvim.client.note.exists"),
  getpath = require("nb-nvim.client.note.getpath"),
  list = require("nb-nvim.client.note.list"),
  print = require("nb-nvim.client.note.print"),
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

local note = setmetatable({}, mt)

return note
