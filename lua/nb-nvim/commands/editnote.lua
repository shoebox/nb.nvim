local vim = vim
local editor = require("nb-nvim.editor")
local picker = require("nb-nvim.picker")

local M = {}
M.client = nil

function M.setup(client)
  M.client = client
end

function M.openNote(playbook, folder, name)
  local exists = M.client.note.Exists(playbook, folder, name)
  if exists == false then
    vim.notify("Note do not exists at path: " .. playbook .. folder .. name, vim.log.levels.ERROR)
    return
  end

  local ok, content = M.client.note.Print(playbook, folder, name)
  if not ok then
    return
  end

  editor.Edit(name, content, function(editedContent)
    M.client.note.Edit(playbook, folder, name, editedContent)
  end)
end

function M.pickFolder(playbook, folder, cb)
  if not folder then
    picker.folder(M.client, playbook, function(choice)
      cb(choice)
    end)
  else
    cb(folder)
  end
end

function M.pickNote(playbook, folder, name, cb)
  if not name then
    picker.notes(M.client, playbook, folder, function(choice)
      cb(choice)
    end)
  else
    cb(name)
  end
end

function M.callback(obj)
  local playbook = M.client.config.playbook
  local folder = obj.fargs[1]
  local noteName = obj.fargs[2]

  M.pickFolder(playbook, folder, function(selectedFolder)
    M.pickNote(playbook, selectedFolder, noteName, function(filename)
      M.openNote(playbook, selectedFolder, filename)
    end)
  end)
end

return M
