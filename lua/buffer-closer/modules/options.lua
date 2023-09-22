---
-- This module is provides the default options for the plugin and functions to
-- wok with the options.
--
local M = {}
local validate = vim.validate

---
-- Default options for the `buffer-closer` plugin.
--
-- @table DEFAULT_OPTIONS
-- @field min_remaining_buffers: The minimum number of buffers to keep open.
-- @field retirement_minutes: The number of minutes after which a buffer is considered retired.
--
-- @field events: A table of events to trigger the buffer-closer.
-- @field timed_check: A table of options for automatically checking for retired buffers after a given number of minutes.
-- @field timed_check.enabled: Whether to automatically check for retired buffers after a given number of minutes.
-- @field timed_check.interval_minutes: The number of minutes after which to automatically check for retired buffers.
--
-- @field run_when_min_buffers_reached: A table of options for running the buffer-closer when the number of buffers is
-- greater than the given number.(not implemented yet)
-- @field run_when_min_buffers_reached.enabled: Whether to run the buffer-closer when the number of buffers is greater
-- than the given number.(not implemented yet)
-- @field run_when_min_buffers_reached.min_buffers: The number of buffers to reach before running the buffer-closer.(not implemented yet)
--
-- @field excluded: A table of excluded filetypes, buffer types, and filenames.
-- @field excluded.filetypes: A table of excluded filetypes.
-- @field excluded.buftypes: A table of excluded buffer types.
-- @field excluded.filenames: A table of excluded filenames.
-- @field ignore_working_windows: Whether to ignore buffers open in windows.
M.DEFAULT_OPTIONS = {
	min_remaining_buffers = 2, -- can not be less than 1
	retirement_minutes = 3, -- can not be less than 1

	events = "default", -- (table, "default", "disabled"): close the buffer when the given events are triggered (see :h autocmd-events)
	timed_check = {
		enabled = false,
		interval_minutes = 1, -- can not be less than 1
	},

	-- TODO: implement this
	-- this option will be used to run the buffer-closer when the number of buffers is greater than the given number
	run_when_min_buffers_reached = {
		enabled = false,
		min_buffers = 3, -- can not be less than 1
	},

	excluded = {
		filetypes = { "lazy", "NvimTree" },
		buftypes = { "terminal", "nofile", "quickfix", "prompt", "help" },
		filenames = {},
	},

	-- it means that a buffer will not be closed if it is opened in a window
	ignore_working_windows = true,
}

--- Default events for the `buffer-closer` option `events`.
--- @table DEFAULT_EVENTS
M.DEFAULT_EVENTS = { "BufAdd", "FocusLost", "FocusGained" }

---
--- Validates the plugin options.
---
--- This function validates the given options table against a schema and returns the validated options. If the options
--- are not valid, an error is thrown.
---
--- @function validate_opts
--- @tparam table opts: The options table to validate.
--- @return table|nil : The validated options table if the options are valid, otherwise nil.
M.validate_opts = function(opts)
	local success, error_msg = pcall(function()
		validate { opts = { opts, "table", true } }

		if opts then
			validate {
				min_remaining_buffers = {
					opts.min_remaining_buffers,
					function(val) return val == nil or type(val) == "number" and val > 0 end,
					"Min remaining buffers can not be less than 1",
				},

				retirement_minutes = {
					opts.retirement_minutes,
					function(val) return val == nil or type(val) == "number" and val > 0 end,
					"Retirement minutes can not be less than 1",
				},

				events = {
					opts.events,
					function(val)
						if type(val) == "string" then return val == "default" or val == "disabled" end
						return val == nil or type(val) == "table"
					end,
					"Events can only be `default`, `disabled`, table, or nil",
				},

				timed_check = { opts.timed_check, "table", true },

				run_when_min_buffers_reached = { opts.run_when_min_buffers_reached, "table", true },

				excluded = { opts.excluded, "table", true },

				ignore_working_windows = { opts.ignore_working_windows, "boolean", true },
			}

			if opts.timed_check then
				validate {
					["timed_check.enabled"] = {
						opts.timed_check.enabled,
						"boolean",
					},
					["timed_check.interval_minutes"] = {
						opts.timed_check.interval_minutes,
						function(val) return val == nil or type(val) == "number" and val > 0 end,
						"Auto check interval minutes can not be less than 1",
					},
				}
			end

			if opts.run_when_min_buffers_reached then
				validate {
					["run_when_min_buffers_reached.enabled"] = {
						opts.run_when_min_buffers_reached.enabled,
						"boolean",
					},
					["run_when_min_buffers_reached.min_buffers"] = {
						opts.run_when_min_buffers_reached.min_buffers,
						function(val) return val == nil or type(val) == "number" and val > 0 end,
						"Min buffers can not be less than 1",
					},
				}
			end

			if opts.excluded then
				validate {
					["excluded.filetypes"] = { opts.excluded.filetypes, "table", true },
					["excluded.buftypes"] = { opts.excluded.buftypes, "table", true },
					["excluded.filenames"] = { opts.excluded.filenames, "table", true },
				}
			end
		end
	end)

	if not success then
		error("Error: " .. error_msg)
		return nil
	end

	return opts
end

---
--- Applies the user options to the default options.
---
--- This function replaces the user options with the default options and returns the resulting options table.
---
--- @function apply_user_options
--- @tparam table user_opts: The user options to apply.
--- @return table: The resulting options table.
---
--- @see DEFAULT_OPTIONS
--- @see validate_opts
M.apply_user_options = function(user_opts)
	user_opts = M.validate_opts(user_opts)
	return vim.tbl_deep_extend("force", M.DEFAULT_OPTIONS, user_opts or {})
end

return M
