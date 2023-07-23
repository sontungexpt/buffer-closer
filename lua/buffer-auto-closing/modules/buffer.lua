local M = {}

M.buffers = {
  -- [buffer] = leave-time
  -- [using buffer] = 0
}

M.save_buffer_leave_time = function()
  local buffer = vim.api.nvim_get_current_buf()
  local now = vim.loop.now()
  M.buffers[buffer] = now
end


M.save_buffer_enter_time = function()
  local buffer = vim.api.nvim_get_current_buf()
  local now = vim.loop.now()
  M.buffers[buffer] = 0
end



return M
