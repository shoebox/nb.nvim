local FLAG_TYPE = "--type"
local TYPENOTE = "note"
local FLAG_CONTENT = "--content"

local M = {}
local executor = require("nb-nvim.client.executor")

M.Add = function(playbook, folder, name, content)
  if not content then
    content = "empty"
  end

  local args = {
    FLAG_CONTENT,
    content,
    FLAG_TYPE,
    TYPENOTE,
  }

  local cmd = executor
    .New()
    .setPlaybook(playbook)
    .setFolder(folder)
    .setName(name)
    .setExtraArgs(args)
    .setCmd("add")
    .execute()

  local ok = cmd.exitCode == 0
  if ok == 0 then
    vim.notify("Note added successfully")
  end

  return ok
end

return M
