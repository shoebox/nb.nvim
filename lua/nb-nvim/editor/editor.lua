local vim = vim
local M = {}

function M.CreateTempBuffer()
	vim.cmd("vsplit")

	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, false)

	vim.api.nvim_buf_set_option(buf, "filetype", "asciidoc")
	vim.api.nvim_buf_set_name(buf, os.tmpname() .. ".adoc")
	vim.api.nvim_win_set_buf(win, buf)

	return buf
end

function M.BufWritePostAutocmd(callback, bufferID)
	local group = vim.api.nvim_create_augroup("nb_nvim", { clear = true })

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = group,
		callback = callback,
		buffer = bufferID,
	})
end

function M.GetBufferLines(bufferID)
	local content = vim.api.nvim_buf_get_lines(bufferID, 0, -1, false)
	content = table.concat(content, "\n")

	return content
end

return M
