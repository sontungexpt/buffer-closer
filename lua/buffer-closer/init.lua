---
-- The main plugin module
--
-- This module provides functions for setting up and configuring the buffer-closer plugin.
--
local timer_module = require("buffer-closer.modules.timer")

local Plugin = {}

---
-- Plugin module provides options for the `buffer-closer` plugin.
-- Default options for the `buffer-closer` plugin.
-- @table DEFAULT_OPTS
-- @field min_remaining_buffers The minimum number of buffers to keep open.
-- @field retirement_minutes The number of minutes after which a buffer is considered retired.
-- @field checking_interval_minutes The interval, in minutes, at which to check for retired buffers.
-- @field excluded A table of excluded filetypes, buffer types, and filenames.
-- @field excluded.filetypes A table of excluded filetypes.
-- @field excluded.buftypes A table of excluded buffer types.
-- @field excluded.filenames A table of excluded filenames.
-- @field ignore_working_windows Whether to ignore buffers open in windows.
Plugin.DEFAULT_OPTS = {
  min_remaining_buffers = 1,
  retirement_minutes = 1,        -- can not be less than 1
  checking_interval_minutes = 1, -- can not be less than 1

  excluded = {
    filetypes = { "lazy", "NvimTree" },
    buftypes = { "terminal", "nofile", "quickfix", "prompt", "help" },
    filenames = {},
  },

  -- it means that a buffer will not be closed if it is opened in a window
  ignore_working_windows = true,
}

---
-- Validates the plugin options.
--
-- This function validates the given options table against a schema and returns the validated options. If the options
-- are not valid, an error is thrown.
--
-- @param opts table The options table to validate.
-- @return table The validated options table.
--
Plugin.validate_opts = function(opts)
  local success, error_msg = pcall(function()
    vim.validate { opts = { opts, "table", true } }

    if opts then
      vim.validate {
        min_remaining_buffers = { opts.min_bufs, "number", true },
        checking_interval_minutes = { opts.checking_interval_minutes, "number", true },
        retirement_minutes = { opts.retirement_minutes, "number", true },
        excluded = { opts.excluded, "table", true },
        ignore_working_windows = { opts.ignore_working_windows, "boolean", true },
      }
    end

    if opts.excluded then
      vim.validate {
        ["excluded.filetypes"] = { opts.excluded.filetypes, "table", true },
        ["excluded.buftypes"] = { opts.excluded.buftypes, "table", true },
        ["excluded.filenames"] = { opts.excluded.filenames, "table", true },
      }
    end
  end)

  if not success then
    error("Error: " .. error_msg)
    return nil
  end

  if opts.retirement_minutes and opts.retirement_minutes < 1 then
    error("Error: retirement_minutes can not be less than 1")
    return nil
  end

  if opts.checking_interval_minutes and opts.checking_interval_minutes < 1 then
    error("Error: checking_interval_minutes can not be less than 1")
    return nil
  end

  return opts
end

---
-- Applies the user options to the default options.
--
-- This function replaces the user options with the default options and returns the resulting options table.
--
-- @param user_opts table The user options to apply.
-- @return table The resulting options table.
--
Plugin.apply_user_options = function(user_opts)
  user_opts = Plugin.validate_opts(user_opts)
  return vim.tbl_deep_extend("force", Plugin.DEFAULT_OPTS, user_opts or {})
end

---
-- Sets up the plugin with the user options.
--
-- This function sets up the buffer-closer plugin with the given options.
--
-- @param user_opts table The user options to apply to the plugin, it will replace the default options.
--
-- @see buffer-closer.modules.timer.init
Plugin.setup = function(user_opts)
  local options = Plugin.apply_user_options(user_opts)
  timer_module.init(options)
end

return Plugin
