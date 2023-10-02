--- This module is responsible for setting up the autocmds for the plugin.
--
local M = {}

local autocmd = vim.api.nvim_create_autocmd

local buffer_module = require("buffer-closer.modules.buffer")
local option_module = require("buffer-closer.modules.options")

---
--- This function initializes the autocmds for the plugin, as specified by the given options.
--- @function setup
--- @tparam table user_opts : The options for the plugin.
--- @see buffer-closer.setup
--- @see buffer-closer.modules.buffer.close_retired_buffers
--- @see buffer-closer.modules.options.DEFAULT_EVENTS
M.setup = function(user_opts)
	local events = user_opts.events
	if type(events) == "string" then
		if events == "default" then
			events = option_module.DEFAULT_EVENTS
		elseif events == "disabled" then
			return
		end
	end
	-- if user_opts.events then events = user_opts.events end
	if #events > 0 then
		autocmd(events, {
			group = vim.api.nvim_create_augroup("BufferCloserAutocmd", { clear = true }),
			pattern = "*",
			command = "BufferCloserRetire",
		})
	end
end

return M
