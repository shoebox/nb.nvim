local M = {}
local ui = require("nb-nvim.ui")

function M.folder(client, playbook, cb)
  print("pick folder", client, playbook)
  local ok, folders = client.notebook.ListFolders(playbook)
  if ok == false then
    return false
  end

  local filtered = {}
  for _, item in ipairs(folders) do
    if item ~= "" then
      table.insert(filtered, item)
    end
  end

  return ui.pickone(filtered, "Choose folder", nil, cb)
end

return M
