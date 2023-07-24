local buffer_module = require('buffer-auto-closing.modules.buffer')

local M = {}

M.init = function(opts)
  local timer = vim.loop.new_timer()
  local run_time_start = opts.retirement_mins * 60000
  local interval_time = opts.interval_checking_mins * 60000

  -- just start after interval time
  timer:start(run_time_start, interval_time, vim.schedule_wrap(function()
    buffer_module.close_retired_buffers(opts)
  end))
end

return M
