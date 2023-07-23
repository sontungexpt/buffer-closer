local M = {}

M.buffers = {
  -- [buffer] = leave-time
  -- [working buffer] = 0
}

M.save_buffer_leave_time = function()
  local buffer = vim.api.nvim_get_current_buf()
  local now = vim.loop.now()
  print("save_buffer_leave_time", buffer, now)
  M.buffers[buffer] = now
end


M.save_buffer_enter_time = function()
  local buffer = vim.api.nvim_get_current_buf()
  print("save_buffer_leave_time", buffer)
  M.buffers[buffer] = 0
end

M.is_working_buffer = function(buffer)
  return M.buffers[buffer] == 0
end

M.is_outdated_buffer = function(buffer, retirement_mins)
  local now = vim.loop.now()
  local leave_time = M.buffers[buffer]
  local mins = (now - leave_time) / 1000 / 60
  return mins > retirement_mins
end

M.remove_buffer = function(buffer)
  M.buffers[buffer] = nil
end

M.is_unsaved_buffer = function(buffer)
  return vim.api.nvim_buf_get_option(buffer, "modified")
end


return M
