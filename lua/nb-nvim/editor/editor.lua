local vim = vim
local M = {}

function M.Edit(name, content, callback)
  local bufferID = M.CreateTempBuffer(name, content)
  M.BufWritePostAutocmd(callback, bufferID)
end

function M.CreateTempBuffer(name, content)
  vim.cmd("vsplit")

  local win = vim.api.nvim_get_current_win()
  local bufferID = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_win_set_buf(win, bufferID)
  vim.api.nvim_buf_set_option(bufferID, "filetype", "asciidoc")
  vim.api.nvim_buf_set_lines(bufferID, 0, -1, false, content)
  vim.api.nvim_buf_set_name(bufferID, os.tmpname() .. ".adoc")

  return bufferID
end

function M.BufWritePostAutocmd(callback, bufferID)
  local group = vim.api.nvim_create_augroup("nb_nvim", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = group,
    callback = function()
      local content = M.GetBufferLines(bufferID)
      callback(content)
    end,
    buffer = bufferID,
  })
end

function M.GetBufferLines(bufferID)
  local content = vim.api.nvim_buf_get_lines(bufferID, 0, -1, false)
  content = table.concat(content, "\n")

  return content
end

return M
