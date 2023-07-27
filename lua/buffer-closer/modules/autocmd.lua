--- This module is responsible for setting up the autocmds for the plugin.
--
local M = {}

local autocmd = vim.api.nvim_create_autocmd

local buffer_module = require("buffer-closer.modules.buffer")

---
-- This function initializes the autocmds for the plugin, as specified by the given options.
--
-- @function init
-- @param opts (table): The options for the plugin.
-- @see buffer-closer.setup
-- @see buffer-closer.modules.buffer.close_retired_buffers
M.init = function(opts)
	if not opts.check_when_buffer_adding then return end

	autocmd("BufAdd", {
		group = vim.api.nvim_create_augroup("BufferCloserAutocmd", {}),
		pattern = "*",
		callback = function() buffer_module.close_retired_buffers(opts) end,
	})
end

return M