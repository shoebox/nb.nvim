local M = {}
local clientconfig = require("nb-nvim.client.config")

M.playbook = "shoebox"
M.debug = false
M.extension = nil

function M.setup()
  if not M.extension then
    local ext = clientconfig.Get("default_extension")
    if not ext then
      vim.notify("failed to infer default extension from configuration")
    end

    print("set default extension to " .. ext)
    M.extension = ext
  end
end

return M
