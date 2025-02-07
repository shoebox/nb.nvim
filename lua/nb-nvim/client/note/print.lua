local M = {}
local executor = require("nb-nvim.client.executor")
local vim = vim

M.Print = function(playbook, folder, name)
  local res = M.executeCmd(playbook, folder, name)
  if res.exitCode ~= 0 then
    return false
  end

  local lines = vim.split(res.stdout, "\n")
  return res.exitCode == 0, lines
end

M.executeCmd = function(playbook, folder, name)
  return executor
    .New()
    .setPlaybook(playbook)
    .setFolder(folder)
    .setName(name)
    .setCmd("show")
    .setArgs({ "--no-color", "--print" })
    .execute()
end

return M
