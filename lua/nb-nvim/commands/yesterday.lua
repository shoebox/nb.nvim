local journal = require("nb-nvim.journal")

local function getNoteName()
	local date = journal.getDateWithOffset(-1)

	return date
end

return function(client)
	local playbook = "shoebox"
	local date = getNoteName()

	local notePath = client.note.GetPath(playbook, "journal", date)

	-- checking if note already exists
	local exists = client.note.Exists(notePath)
	if exists then
		vim.notify("Note already at path: " .. notePath, vim.log.levels.ERROR)
		return
	end
	--
	-- adds note to playbook
	local ok = client.note.Add(notePath, date)
	if ok == false then
		vim.notify("Failed to add note at path: " .. notePath, vim.log.levels.ERROR)
		return
	end

	return client.note.Open(notePath)
end
