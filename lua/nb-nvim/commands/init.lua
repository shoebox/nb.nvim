local vim = vim

local commands_map = {
  NbAddNote = "nb-nvim.commands.addnote",
  NbEditNote = "nb-nvim.commands.editnote",
  NbSelectNotebook = "nb-nvim.commands.notebookselect",
  NbToday = "nb-nvim.commands.today",
  NbTomorrow = "nb-nvim.commands.tomorrow",
  NbYesterday = "nb-nvim.commands.yesterday",
}

local M = setmetatable({
  commands = {},
}, {
  __index = function(t, k)
    local path = commands_map[k]
    if not path then
      return
    end

    local mod = require(path)
    t[k] = require(path)

    return mod
  end,
})

M.registerCmd = function(name, config)
  if not config.func then
    config.func = function(client, data)
      return M[name].callback(client, data)
    end
  end

  M.commands[name] = config
end

M.setup = function(client)
  for name, cmd in pairs(M.commands) do
    M[name].setup(client)

    vim.api.nvim_create_user_command(name, cmd.func, cmd.opts)
  end
end

M.registerCmd("NbAddNote", {
  opts = {
    nargs = "*",
    desc = "Adds a new note into the notebook",
  },
})

M.registerCmd("NbEditNote", {
  opts = {
    nargs = "*",
    desc = "Edit a note into the notebook",
  },
})

M.registerCmd("NbToday", {
  opts = {
    nargs = 0,
    desc = "Adds or edit a journal entry in the notebook for today",
  },
})

M.registerCmd("NbTomorrow", {
  opts = {
    nargs = 0,
    desc = "Adds or edit a journal entry in the notebook for tomorrow",
  },
})

M.registerCmd("NbYesterday", {
  opts = {
    nargs = 0,
    desc = "Adds or edit a journal entry in the notebook for yesterday",
  },
  { offset = -1 },
})

M.registerCmd("NbSelectNotebook", {
  opts = {
    nargs = "*",
    desc = "Select the active notebook",
  },
  { offset = -1 },
})

return M
