local M = {}
local vim = vim

function M.prompt(msg, opts)
  opts = opts or {}

  -- Ensure the prompt ends with two spaces
  if not vim.endswith(msg, " ") then
    msg = msg .. " "
  end

  local name
  vim.ui.input({ prompt = msg }, function(choice)
    name = choice
  end)

  return name
end

return M
