local get_buf_opt = vim.api.nvim_buf_get_option

local M = {}

M.is_excluded = function(bufnr, excluded)
	if excluded then
		local filetype = get_buf_opt(bufnr, "filetype")
		local buftype = get_buf_opt(bufnr, "buftype")
		local filename = vim.fn.expand("%:t")
		local contains = vim.tbl_contains
		if
			contains(excluded.filetypes, filetype)
			or contains(excluded.buftypes, buftype)
			or contains(excluded.filenames, filename)
		then
			return true
		end
	end
	return false
end

M.is_unsaved_buffer = function(bufnr) return get_buf_opt(bufnr, "modified") end

M.is_outdated_buffer = function(lastused_secs, retirement_mins)
	local now = os.time() -- in seconds
	return now - lastused_secs > retirement_mins * 60
end

-- local print_to_file = function(msg)
-- 	local file = io.open(
-- 		"/home/stilux/Data/My-Workspaces/nvim-extensions/buffer-auto-closing/lua/buffer-auto-closing/test.txt",
-- 		"a"
-- 	)
-- 	if file == nil then return end
-- 	local filename = vim.fn.expand("%")
-- 	file:write(filename .. "\n")
-- 	file:write(msg .. "\n")
-- 	file:close()
-- end

M.get_retired_bufnrs = function(opts)
	local buffers = vim.fn.getbufinfo { buflisted = 1 }
	if #buffers <= opts.min_remaining_bufs then return {} end

	local retired_buffers = vim.tbl_filter(function(buffer)
		local bufnr = buffer.bufnr
		return not M.is_unsaved_buffer(bufnr)
			and M.is_outdated_buffer(buffer.lastused, opts.retirement_mins)
			and not (opts.ignore_working_window and #buffer.windows > 0)
			and not M.is_excluded(bufnr, opts.excluded)
	end, buffers)

	local num_after_removing_retired = #buffers - #retired_buffers
	-- full: 6
	-- retired: 5
	-- min_remaining: 4
	-- num_after_removing_retired: 1
	--
	if num_after_removing_retired < opts.min_remaining_bufs then
		table.sort(retired_buffers, function(a, b) return a.lastused < b.lastused end)
		retired_buffers =
			vim.list_slice(retired_buffers, 1, opts.min_remaining_bufs - num_after_removing_retired)
	end

	return vim.tbl_map(function(buffer) return buffer.bufnr end, retired_buffers)
end

-- M.get_retired_bufnrs = function(opts)
-- 	local buffers = vim.fn.getbufinfo { buflisted = 1 }
-- 	if #buffers <= opts.min_remaining_bufs then return {} end

-- 	local retired_bufnrs = {}
-- 	for _, buffer in ipairs(buffers) do
-- 		local bufnr = buffer.bufnr
-- 		if
-- 			not M.is_unsaved_buffer(bufnr)
-- 			and M.is_outdated_buffer(buffer.lastused, opts.retirement_mins)
-- 			and not (opts.ignore_working_window and #buffer.windows > 0)
-- 			and not M.is_excluded(bufnr, opts.excluded)
-- 		then
-- 			retired_bufnrs[#retired_bufnrs + 1] = bufnr
-- 		end
-- 	end

-- 	return retired_bufnrs
-- end

M.close_retired_buffers = function(opts)
	local retired_bufnrs = M.get_retired_bufnrs(opts)

	if #retired_bufnrs > 0 then
		local has_notify, _ = pcall(require, "notify")
		if has_notify then
			vim.notify("buffer-auto-closing: closing retired buffers")
		else
			print("buffer-auto-closing: closing retired buffers")
		end

		vim.tbl_map(function(bufnr) vim.api.nvim_buf_delete(bufnr, { force = true }) end, retired_bufnrs)
	end
end

return M
