local timer_module = require("buffer_auto_closing.modules.timer")

local M = {}

M.DEFAULT_OPTS = {
  min_bufs = 1,
  retirement_mins = 5,
  apply_each_buffer = false, -- TODO: implement this
  excluded = {
    filetypes = { "lazy" },
    buftypes = { "terminal" },
    bufnames = { "NvimTree" },
  },
  ignore_unsaved = true,
  ignore_visible = true,
}

M.validate_opts = function(opts)
  vim.validate {
    opts = { opts, "table" }
  }

  vim.validate {
    min_bufs = { opts.min_bufs, "number" },
    retirement_mins = { opts.retirement_mins, "number" },
    apply_each_buffer = { opts.apply_each_buffer, "boolean" },
    ignore_unsaved = { opts.ignore_unsaved, "boolean" },
    ignore_visible = { opts.ignore_visible, "boolean" },
    excluded = { opts.excluded, "table" },
  }

  vim.validate {
    ["excluded.filetypes"] = { opts.excluded.filetypes, "table" },
    ["excluded.buftypes"] = { opts.excluded.buftypes, "table" },
    ["excluded.bufnames"] = { opts.excluded.bufnames, "table" },
  }

  if vim.tbl_count(vim.validate.result) > 0 then
    return {}
  end

  return opts
end



--------------------------------------------------------------------------------
M.apply_options = function(user_opts)
  user_opts = M.validate_opts(user_opts)

  return vim.tbl_deep_extend("force", M.DEFAULT_OPTS, user_opts or {})
end

function M.setup(user_opts)
  local options = M.apply_options(user_opts)

  timer_module.start(options)
end

return M
