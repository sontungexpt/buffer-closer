local timer_module = require("buffer-auto-closing.modules.timer")

local Plugin = {}

Plugin.DEFAULT_OPTS = {
  min_remaining_bufs = 1,
  retirement_mins = 1,        -- can not be less than 1
  interval_checking_mins = 1, -- can not be less than 1

  excluded = {
    filetypes = { "lazy", "NvimTree", "packer", "startify", "terminal", "toggleterm" },
    buftypes = { "terminal", 'nofile', 'quickfix', 'prompt', 'help' },
    filenames = {}
  },

  -- it means that a buffer will not be closed if it is opened in a window
  ignore_working_window = true,
}

Plugin.validate_opts = function(opts)
  local success, error_msg = pcall(function()
    vim.validate({ opts = { opts, 'table', true } })

    if opts then
      vim.validate({
        min_remaining_bufs = { opts.min_bufs, 'number', true },
        interval_checking_mins = { opts.interval_checking_mins, 'number', true },
        retirement_mins = { opts.retirement_mins, 'number', true },
        excluded = { opts.excluded, 'table', true },
        ignore_working_window = { opts.ignore_working_window, 'boolean', true },
      })
    end

    if opts.excluded then
      vim.validate({
        ['excluded.filetypes'] = { opts.excluded.filetypes, 'table', true },
        ['excluded.buftypes'] = { opts.excluded.buftypes, 'table', true },
        ['excluded.filenames'] = { opts.excluded.filenames, 'table', true },
      })
    end
  end)

  if not success then
    error("Error: " .. error_msg)
    return nil
  end

  if opts.retirement_mins and opts.retirement_mins < 1 then
    error("Error: retirement_mins can not be less than 1")
    return nil
  end

  if opts.interval_checking_mins and opts.interval_checking_mins < 1 then
    error("Error: interval_checking_mins can not be less than 1")
    return nil
  end

  return opts
end

Plugin.apply_user_options = function(user_opts)
  user_opts = Plugin.validate_opts(user_opts)
  return vim.tbl_deep_extend("force", Plugin.DEFAULT_OPTS, user_opts or {})
end

--------------------------------------------------------------------------------
Plugin.setup = function(user_opts)
  local options = Plugin.apply_user_options(user_opts)
  timer_module.init(options)
end

return Plugin
