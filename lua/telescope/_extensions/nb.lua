local vim = vim
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local make_entry = require("telescope.make_entry")
local utils = require("telescope.utils")
local git_command = utils.__git_command
local previewers = require("telescope.previewers")

local function notebooks_ls()
	local obj = vim.system({ "nb", "notebooks", "--name", "--no-color" }, { text = true }):wait()
	if obj.code ~= 0 then
		return nil, false
	end

	return vim.split(obj.stdout, "\n"), true
end

local select_notebook = function()
	local list, ok = notebooks_ls()
	print(ok, list)
	opts = opts or {}

	pickers
		.new(opts, {
			prompt_title = "select nb notebook",
			finder = finders.new_table(list),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					print(vim.inspect(selection))
				end)

				return true
			end,
		})
		:find()
end

local function nb_filesearch(prompt)
	local obj = vim.system({ "nb", "search", "--path", "--no-color", prompt }, { text = true }):wait()
	if obj.code ~= 0 then
		return nil, false
	end

	return vim.split(obj.stdout, "\n"), true
end

function search_files_with_text()
	pickers
		.new({
			prompt_title = "Search Files",
			results_title = "File Paths",
			finder = finders.new_dynamic({
				fn = function(prompt)
					return nb_filesearch(prompt)
				end,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
						path = entry,
					}
				end,
			}),
			sorter = conf.generic_sorter({}), -- Disables fuzzy filtering
		})
		:find()
end

search_files_with_text()
