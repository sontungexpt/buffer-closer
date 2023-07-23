local buffer_module = require("buffer-auto-closing.modules.buffer")
local utils_module = require("buffer-auto-closing.modules.utils")

local M = {}
M.init = function(opts)
  local autocmd = vim.api.nvim_create_autocmd

  autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup('BufferAutoClosing', {}),
    pattern = "*",
    callback = function(_)
      local buffer = vim.api.nvim_get_current_buf()

      if utils_module.is_excluded_ft(opts.excluded_filetypes, vim.api.nvim_buf_get_option(buffer, 'filetype'))
          or utils_module.is_excluded_bt(opts.excluded_buftypes, vim.api.nvim_buf_get_option(buffer, 'buftype'))
          or utils_module.is_excluded_bn(opts.excluded_bufnames, vim.api.nvim_buf_get_name(buffer))
      then
        return
      end
      buffer_module.save_buffer_enter_time()
    end,
  })

  autocmd({ "BufLeave" }, {
    group = vim.api.nvim_create_augroup('BufferAutoClosing', {}),
    pattern = "*",
    callback = function(_)
      local buffer = vim.api.nvim_get_current_buf()

      if utils_module.is_excluded_ft(opts.excluded_filetypes, vim.api.nvim_buf_get_option(buffer, 'filetype'))
          or utils_module.is_excluded_bt(opts.excluded_buftypes, vim.api.nvim_buf_get_option(buffer, 'buftype'))
          or utils_module.is_excluded_bn(opts.excluded_bufnames, vim.api.nvim_buf_get_name(buffer))
      then
        return
      end
      buffer_module.save_buffer_leave_time()
    end,
  })
end

return M
