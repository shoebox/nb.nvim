local journal = require("nb-nvim.journal")

local M = {}
M.client = nil

function M.setup(client)
  M.client = client
end

function M.callback()
  return journal.open(0)
end

return M
