local editor = require("nb-nvim.editor.editor")
local picker = require("nb-nvim.picker")
local ui = require("nb-nvim.ui")
local vim = vim

local M = {}
M.client = nil

function M.setup(client)
  M.client = client
end

function M.callback(obj)
  local playbook = M.client.config.playbook
  local folder = obj.fargs[1]
  local noteName = obj.fargs[2]
  if not folder then
    picker.folder(M.client, playbook, function(choice)
      M.addNoteInFolder(playbook, choice, noteName)
    end)
  else
    M.addNoteInFolder(playbook, folder, noteName)
  end
end

function M.addNoteInFolder(playbook, folder, name)
  if not name then
    name = ui.prompt("Enter note title: ", {})
  end

  local ok = M.client.note.Add(playbook, folder, name)
  if not ok then
    return
  end

  local exists = M.client.note.Exists(playbook, folder, name)
  if exists == false then
    vim.notify("Note do not exists at path: " .. playbook .. folder .. name, vim.log.levels.ERROR)
    return
  end

  local content
  ok, content = M.client.note.Print(playbook, folder, name)
  if not ok then
    return
  end

  editor.Edit(name, content, function(editedContent)
    M.client.note.Edit(playbook, folder, name, editedContent)
  end)
end

return M
