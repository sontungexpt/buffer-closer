local get_buf_opt = vim.api.nvim_buf_get_option

local M = {}

M.is_excluded = function(bufnr, excluded)
  if excluded then
    local filetype = get_buf_opt(bufnr, 'filetype')
    local buftype = get_buf_opt(bufnr, 'buftype')
    local filename = vim.fn.expand("%:t")
    local contains = vim.tbl_contains
    if contains(excluded.filetypes, filetype)
        or contains(excluded.buftypes, buftype)
        or contains(excluded.filenames, filename)
    then
      return true
    end
  end
  return false
end

-- check conditions
M.is_unsaved_buffer = function(bufnr)
  return get_buf_opt(bufnr, "modified")
end

M.is_working_buffer = function(buffer)
  return M.opened_buffers[buffer] == 0
end

M.is_outdated_buffer = function(buf_last_used_time_secs, retirement_mins)
  local now = os.time() -- ms
  local retirement_secs = retirement_mins * 60
  return now - buf_last_used_time_secs > retirement_secs
end

M.is_in_working_window = function(bufnr)
  return vim.fn.bufwinnr(bufnr) ~= -1
end

M.close_retired_buffers = function(opts)
  local remove_bufnrs = {}

  for _, buffer in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    local bufnr = buffer.bufnr
    if vim.api.nvim_buf_is_valid(bufnr) and
        not M.is_unsaved_buffer(bufnr) and
        M.is_outdated_buffer(buffer.lastused, opts.retirement_mins) and
        not (opts.ignore_working_window and M.is_in_working_window(bufnr)) and
        not M.is_excluded(bufnr, opts.excluded)
    then
      table.insert(remove_bufnrs, bufnr)
    end
  end

  if #remove_bufnrs > opts.min_remaining_bufs then
    print("buffer-auto-closing: closing retired buffers")
    vim.tbl_map(function(bufnr)
      if vim.api.nvim_buf_is_loaded(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true, unload = true })
      else
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end, remove_bufnrs)
  end
end

return M
