local M = {}

M.client = nil

function M.setup(client)
	M.client = client
	return M
end

function M.getDateWithOffset(offset)
	return os.date("%Y-%b-%d", os.time() + offset * 24 * 60 * 60)
end

function M.createEntry(notePath, name)
	return M.client.note.Add(notePath, name)
end

function M.entryExists(notePath)
	return M.client.note.Exists(notePath)
end

function M.openEntry(notePath)
	return M.client.note.Open(notePath)
end

function M.open(offset)
	local date = M.getDateWithOffset(offset)
	local notePath = M.client.note.GetPath(M.client.config.playbook, "journal", date)

	-- checking if note already exists
	if M.entryExists(notePath) then
		vim.notify("Note already at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	-- adds note to playbook
	if not M.createEntry(notePath, date) then
		vim.notify("Failed to add note at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	return M.openEntry(notePath)
end

return M
