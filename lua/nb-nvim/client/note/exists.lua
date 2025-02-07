local exec = require("nb-nvim.client.execute")
local executor = require("nb-nvim.client.executor")

local M = {}

M.Exists = function(playbook, folder, name)
  local res = executor
    .New()
    .setPlaybook(playbook)
    .setFolder(folder)
    .setName(name)
    .setCmd("list")
    .setArgs({ "--no-color", "--no-id" })
    .execute()

  return res.exitCode == 0
end

return M
