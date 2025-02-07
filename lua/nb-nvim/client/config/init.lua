local M = {}
local executor = require("nb-nvim.client.executor")

M.Get = function(key)
  local res = executor.New().setCmd("config").setArgs({ "get", key }).execute()
  local ok = res.exitCode == 0
  if not ok then
    vim.notify("failed to get configuration key value")
    return
  end

  res.stdout = string.gsub(res.stdout, "%s+", "")
  return res.stdout
end

return M
