local vim = vim
local M = {
  args = {},
  extraArgs = {},
  cmd = nil,
  folder = nil,
  globalargs = {},
  playbook = nil,
  name = nil,
  debug = false,
}

function M.New()
  M.args = {}
  M.extraArgs = {}
  M.cmd = nil
  M.folder = nil
  M.globalargs = {}
  M.playbook = nil
  M.name = nil

  return M
end

function M.playbookCommand(playbook, cmd)
  M.cmd = playbook .. "." .. cmd
  return M
end

function M.setCmd(cmd)
  M.cmd = cmd
  return M
end

function M.setPlaybook(name)
  if name then
    M.playbook = name
  end
  return M
end

function M.setFolder(value)
  if value then
    -- here we trim whitespace from string end of the folder name
    value = string.gsub(value, "%s+", "")

    -- here we add a trailing slash to the folder name if it does not exist
    if value.sub(value, -1) ~= "/" then
      value = value .. "/"
    end

    M.folder = value
  end
  return M
end

function M.setName(name)
  if name then
    M.name = name
  end
  return M
end

function M.setGlobalArgs(args)
  if args then
    M.globalargs = vim.tbl_deep_extend("error", M.globalargs, args)
  end
  return M
end

function M.setArgs(list)
  if list then
    M.args = vim.tbl_deep_extend("keep", M.args, list)
  end
  return M
end

function M.setExtraArgs(list)
  if list then
    M.extraArgs = vim.tbl_deep_extend("keep", M.extraArgs, list)
  end
  return M
end

function M.getPath()
  local path = ""
  if M.playbook then
    path = M.playbook .. ":"
  end

  if M.folder then
    path = path .. M.folder
  end

  if M.name then
    path = path .. M.name
  end

  return path
end

function M.execute(stdin)
  local cmdTable = vim.list_extend({ "nb" }, M.globalargs)
  cmdTable = vim.list_extend(cmdTable, { M.cmd })
  cmdTable = vim.list_extend(cmdTable, M.args)
  cmdTable = vim.list_extend(cmdTable, { M.getPath() })
  cmdTable = vim.list_extend(cmdTable, M.extraArgs)

  if M.debug then
    print("Executing command: " .. table.concat(cmdTable, " "))
  end

  local result = {}
  vim
    .system(cmdTable, { text = true, stdin = stdin or nil }, function(obj)
      result.exitCode = obj.code
      result.stdout = obj.stdout
      result.stderr = obj.stderr
    end)
    :wait()

  return result
end

return M
