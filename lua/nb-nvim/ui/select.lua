local M = {}
local vim = vim

function M.pickone(items, prompt, label_fn, cb)
  if not label_fn then
    label_fn = function(item)
      return item
    end
  end

  vim.ui.select(items, {
    prompt = prompt,
    format_item = label_fn,
  }, cb)
end

return M
