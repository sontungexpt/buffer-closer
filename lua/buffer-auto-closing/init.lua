local timer_module = require("buffer_auto_closing.modules.timer")
local autocmd_module = require("buffer_auto_closing.modules.autocmd")

local Plugin = {}

Plugin.DEFAULT_OPTS = {
  min_bufs = 1,
  retirement_mins = 5,
  apply_each_buffer = false,
  excluded = {
    filetypes = { "lazy", "NvimTree" },
    buftypes = { "terminal" },
    bufnames = {},
  },
  ignore_unsaved = true,
  ignore_visible = true,
}

Plugin.validate_opts = function(opts)
  local validation_result = vim.validate {
    opts = { opts, "table" },
    min_bufs = { opts.min_bufs, "number" },
    retirement_mins = { opts.retirement_mins, "number" },
    apply_each_buffer = { opts.apply_each_buffer, "boolean" },
    ignore_unsaved = { opts.ignore_unsaved, "boolean" },
    ignore_visible = { opts.ignore_visible, "boolean" },
    excluded = { opts.excluded, "table" },
    ["excluded.filetypes"] = { opts.excluded.filetypes, "table" },
    ["excluded.buftypes"] = { opts.excluded.buftypes, "table" },
    ["excluded.bufnames"] = { opts.excluded.bufnames, "table" },
  }

  if next(validation_result) then
    print(table.concat(validation_result, "\n"))
    return nil
  end

  return opts
end

Plugin.apply_user_options = function(user_opts)
  user_opts = Plugin.validate_opts(user_opts)

  return vim.tbl_deep_extend("force", Plugin.DEFAULT_OPTS, user_opts or {})
end

--------------------------------------------------------------------------------
function Plugin.setup(user_opts)
  local options = Plugin.apply_user_options(user_opts)

  autocmd_module.init(options)
  timer_module.init(options)
end

return Plugin
