local M = {}
local executor = require("nb-nvim.client.executor")
local vim = vim

M.List = function()
  local result = executor
    .New()
    .setCmd("notebooks")
    .setExtraArgs({
      "--no-color",
      "--name",
    })
    .execute()

  if result.exitCode ~= 0 then
    return false, nil
  end

  return true, vim.split(result.stdout, "\n")
end

M.ListFolders = function(playbook)
  local result = executor
    .New()
    .setCmd("list")
    .setArgs({
      "--type",
      "folder",
      "--no-color",
      "--no-id",
      "--no-indicator",
    })
    .setPlaybook(playbook)
    .execute()

  if result.exitCode ~= 0 then
    return false, nil
  end

  return true, vim.split(result.stdout, "\n")
end

return M
