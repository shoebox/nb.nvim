local M = {}
local executor = require("nb-nvim.client.executor")

M.List = function(playbook, folder)
  local cmd = executor
    .New()
    .setPlaybook(playbook)
    .setFolder(folder)
    .setArgs({ "--no-id", "--no-indicator" })
    .setCmd("list")
    .execute()

  local ok = cmd.exitCode == 0
  if not ok then
    vim.notify("Failed to edit note: " .. playbook .. folder .. name, vim.log.levels.ERROR)
  end

  return ok, vim.split(cmd.stdout, "\n")
end

return M
