--- This module is responsible for setting up the commands for the plugin.
--

local M = {}
local new_cmd = vim.api.nvim_create_user_command
local buffer = require("buffer-closer.modules.buffer")

--- This function set up the commands for the plugin.
--- @function setup
--- @tparam table user_opts : The options for the plugin.
--- @see buffer-closer.modules.buffer.close_retired_buffers
--- @see buffer-closer.setup
--- @see buffer-closer.modules.options.DEFAULT_OPTIONS
--- @see buffer-closer.modules.options.apply_user_options
M.setup = function(user_opts)
	new_cmd("CloseRetiredBuffers", function()
		vim.schedule(function() buffer.close_retired_buffers(user_opts) end)
	end, { nargs = 0 })
end

return M
