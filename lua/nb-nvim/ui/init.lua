local vim = vim
local M = {}

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

function M.prompt(msg, opts)
	opts = opts or {}

	if not vim.endswith(msg, " ") then
		msg = msg .. " "
	end

	local name
	vim.ui.input({ prompt = msg }, function(input)
		name = input
	end)

	return name
end

return M
