--- A module for managing buffers and closing retired buffers.
-- This module provides functions for managing buffers and closing retired buffers
--
local get_buf_opt = vim.api.nvim_buf_get_option

local M = {}

---
--- Checks whether a buffer is excluded based on the given exclusion criteria.
---
--- This function checks whether the given buffer should be excluded from being closed based on the given exclusion
--- criteria. The exclusion criteria include filetypes, buffer types, and filenames.
---
--- @function is_excluded
--- @tparam number bufnr : The buffer number to check.
--- @tparam table excluded: The exclusion criteria.
--- @return boolean: Whether the buffer should be excluded.
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

---
-- Checks whether a buffer is unsaved.
--
-- This function checks whether the given buffer has unsaved changes.
--
-- @function is_unsaved_buffer
-- @tparam number bufnr: The buffer number to check.
-- @return boolean: Whether the buffer has unsaved changes.
M.is_unsaved_buffer = function(bufnr) return get_buf_opt(bufnr, "modified") end

---
-- Checks whether a buffer is outdated based on the given retirement policy.
--
-- This function checks whether the given buffer is outdated based on the given retirement policy. A buffer is considered
-- outdated if it has not been used in the specified number of minutes.
--
-- @function is_outdated_buffer
-- @tparam number lastused_secs: The timestamp of when the buffer was last used, in seconds.
-- @tparam number retirement_minutes: The number of minutes after which a buffer is considered outdated.
-- @return boolean: Whether the buffer is outdated.
M.is_outdated_buffer = function(lastused_secs, retirement_minutes)
	if lastused_secs <= 0 then return false end -- buffer has never been used before (e.g. new buffer)
	local now = os.time() -- in seconds
	return now - lastused_secs > retirement_minutes * 60
end

---
-- Returns the list of buffer numbers that should be closed based on the
-- retirement policy specified in the options.
--
-- This function returns the list of buffer numbers that should be closed based on the retirement policy specified in the
-- options. Buffers that should be excluded based on the exclusion criteria are not included in the returned list.
--
-- @function get_retired_bufnrs
-- @tparam table opts: The user options.
-- @return table: The list of buffer numbers to close.
-- @see buffer-closer.setup
M.get_retired_bufnrs = function(opts)
	local buffers = vim.fn.getbufinfo { buflisted = 1 }
	if #buffers <= opts.min_remaining_buffers then return {} end

	local retired_buffers = vim.tbl_filter(function(buffer)
		local bufnr = buffer.bufnr
		return not M.is_unsaved_buffer(bufnr)
			and M.is_outdated_buffer(buffer.lastused, opts.retirement_minutes)
			and not (opts.ignore_working_windows and #buffer.windows > 0)
			and not M.is_excluded(bufnr, opts.excluded)
	end, buffers)

	local num_after_removing_retired = #buffers - #retired_buffers
	-- full: 6
	-- retired: 5
	-- min_remaining: 4
	-- num_after_removing_retired: 1
	--
	if num_after_removing_retired < opts.min_remaining_buffers then
		table.sort(retired_buffers, function(a, b) return a.lastused < b.lastused end)
		retired_buffers =
			vim.list_slice(retired_buffers, 1, opts.min_remaining_buffers - num_after_removing_retired)
	end

	return vim.tbl_map(function(buffer) return buffer.bufnr end, retired_buffers)
end

---
--- Closes the retired buffers based on the retirement policy specified in the options.
---
--- This function closes the retired buffers based on the retirement policy specified in the options. Buffers that should
--- be excluded based on the exclusion criteria are not closed.
---
--- @function close_retired_buffers
--- @tparam table opts: The retirement policy options.
--- @see get_retired_bufnrs
--- @see buffer-closer.setup
M.close_retired_buffers = function(opts)
	local retired_bufnrs = M.get_retired_bufnrs(opts)

	if #retired_bufnrs > 0 then
		vim.tbl_map(function(bufnr) vim.api.nvim_buf_delete(bufnr, { force = true }) end, retired_bufnrs)

		vim.schedule(
			function()
				vim.notify("Close retired buffers", vim.log.levels.INFO, opts or { title = "Buffer Closer" })
			end
		)
	end
end

return M
