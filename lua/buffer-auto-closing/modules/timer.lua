local utils_module = require("buffer_auto_closing.modules.utils")

local M = {}

-- get_open_buffers returns a list of buffers that are open and not excluded
M.get_open_buffers = function(opts)
  local valid_buffers = {}
  local open_buffers = vim.fn.getbufinfo { buflisted = 1 }
  for _, buffer in ipairs(open_buffers) do
    if not utils_module.is_excluded_ft(opts.excluded_filetypes, buffer.filetype)
        and not utils_module.is_excluded_bt(opts.excluded_buftypes, buffer.buftype)
        and not utils_module.is_excluded_bn(opts.excluded_bufnames, buffer.bufname)
    then
      table.insert(valid_buffers, buffer)
    end
  end
  return valid_buffers
end


M.init = function(opts)
  local timer = vim.loop.new_timer()
  local interval = opts.retirement_mins * 60 * 1000
  local open_buffers = M.get_open_buffers(opts)

  timer:start(0, interval, vim.schedule_wrap(function()
    open_buffers = M.get_open_buffers(opts)
    if #open_buffers <= opts.min_bufs then
      timer:stop()
      timer:close()
      return
    end

    for _, buffer in ipairs(open_buffers) do
      if not utils_module.is_buffer_visible(buffer) then
        if opts.ignore_unsaved and utils_module.is_buffer_unsaved(buffer) then
          goto continue
        end

        vim.cmd("silent! bdelete! " .. buffer.bufnr)
      end
      ::continue::
    end
  end))
end

return M
