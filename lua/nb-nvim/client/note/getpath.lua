local M = {}

M.GetPath = function(playbook, folder, filename)
  return string.format("%s:%s/%s", playbook, folder, filename)
end

return M
