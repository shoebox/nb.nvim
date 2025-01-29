local vim = vim
local ui = require("nb-nvim.ui")
local M = {}

function M.notebook(client, cb)
	local ok, list = client.notebook.List()
	print("ok", ok)
	print(vim.inspect(list))
	if ok == false then
		return
	end

	print("list", list)

	local filtered = {}
	for _, item in ipairs(list) do
		if item ~= "" then
			table.insert(filtered, item)
		end
	end

	M.pick_one(filtered, "Choose notebook", nil, function(selected)
		cb(selected)
	end)
end

function M.folder(client, playbook, cb)
	local ok, folders = client.notebook.ListFolders(playbook)
	if ok == false then
		return
	end

	local filtered = {}
	for _, item in ipairs(folders) do
		if item ~= "" then
			table.insert(filtered, item)
		end
	end

	M.pick_one(filtered, "Choose folder", nil, function(selected)
		cb(selected)
	end)
end

function M.notes(client, playbook, folder, cb)
	local ok, notes = client.note.List(playbook, folder)
	if not ok then
		return false
	end
	M.pick_one(notes, "Choose note", nil, function(selected)
		cb(selected)
	end)

	return true
end

function M.pick_one(items, prompt, label_fn, cb)
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

function M.pickNoteName()
	local name = ui.prompt("Enter note title: ", {})
	if not name then
		vim.notify("No note name provided", vim.log.levels.ERROR)
		return false, ""
	end

	return true, name
end

return M
