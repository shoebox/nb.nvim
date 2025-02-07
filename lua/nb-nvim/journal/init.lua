local M = {}
local dateUtil = require("date_util")
local editor = require("nb-nvim.editor.editor")

M.client = nil

function M.setup(client)
  M.client = client
  return M
end

function M.open(offset)
  local playbook = M.client.config.playbook
  local name = dateUtil.getDateWithOffset(offset)
  local folder = "journal"
  local exists = M.client.note.Exists(playbook, folder, name)

  -- if not do not exists, let's create it first
  if not exists then
    M.client.note.Add(playbook, folder, name)
  end

  -- retrieving the content of the note
  local ok, content = M.getNoteContent(playbook, folder, name)
  if not ok then
    return
  end

  -- opening the note in the editor
  M.editNote(playbook, folder, name, content)
end

function M.getNoteContent(playbook, folder, name)
  local ok, content = M.client.note.Print(playbook, folder, name)

  return ok, content
end

function M.editNote(playbook, folder, name, content)
  editor.Edit(name, content, function(editedContent)
    M.client.note.Edit(playbook, folder, name, editedContent)
  end)
end

return M
