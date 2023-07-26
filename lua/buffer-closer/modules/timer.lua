---
-- A module for managing a timer for checking retired buffers.
--
-- This module provides functions for initializing a timer that checks for retired buffers at regular intervals.
--
local buffer_module = require("buffer-closer.modules.buffer")

local M = {}

---
-- Initializes the retired buffer checking timer.
--
-- This function initializes a timer that checks for retired buffers at regular intervals, as specified by the given
-- options. The timer starts after the specified retirement time and repeats at the specified checking interval.
--
-- @function init
-- @param opts (table): The options for plugin.
-- @see buffer-closer
-- @see buffer-closer.modules.buffer.close_retired_buffers
--
M.init = function(opts)
	local timer = vim.loop.new_timer()

	-- why + 60000? because the timer starts after the specified retirement time
	-- not at the specified retirement time
	local run_time_start = opts.retirement_minutes * 60000 + 60000
	local interval_time = opts.checking_interval_minutes * 60000

	-- just start after interval time
	timer:start(
		run_time_start,
		interval_time,
		vim.schedule_wrap(function() buffer_module.close_retired_buffers(opts) end)
	)
end

return M
