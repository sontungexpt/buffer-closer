--- This module provides functions for setting up and configuring the buffer-closer plugin.
--

local timer_module = require("buffer-closer.modules.timer")
local option_module = require("buffer-closer.modules.options")
local autocmd_module = require("buffer-closer.modules.autocmd")
local command_module = require("buffer-closer.modules.commands")

local Plugin = {}

---
--- Sets up the plugin with the user options.
---
--- This function sets up the buffer-closer plugin with the given options.
---
--- @function setup
--- @tparam table|nil user_opts : The user options to apply to the plugin, it will replace the default options.
--- @see buffer-closer.modules.commands.setup
--- @see buffer-closer.modules.options.apply_user_options
--- @see buffer-closer.modules.autocmd.setup
--- @see buffer-closer.modules.timer.setup
--- @usage require('buffer-closer').setup({}) (replace `{}` with your `config` table)
Plugin.setup = function(user_opts)
	local opts = option_module.apply_user_options(user_opts)
	command_module.setup(opts)
	autocmd_module.setup(opts)
	timer_module.setup(opts)
end

return Plugin
