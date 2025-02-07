local M = {}
local executor = require("nb-nvim.client.executor")

M.Edit = function(playbook, folder, name, stdin)
  local cmd = executor
    .New()
    .setPlaybook(playbook)
    .setFolder(folder)
    .setName(name)
    .setCmd("edit")
    .setExtraArgs({ "--overwrite" })
    .execute(stdin)

  local ok = cmd.exitCode == 0
  if not ok then
    vim.notify("Failed to edit note: " .. playbook .. folder .. name, vim.log.levels.ERROR)
  end

  return ok
end

return M
