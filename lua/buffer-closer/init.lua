--- This module provides functions for setting up and configuring the buffer-closer plugin.
--

local timer_module = require("buffer-closer.modules.timer")
local option_module = require("buffer-closer.modules.option")
local autocmd_module = require("buffer-closer.modules.autocmd")

local Plugin = {}

---
-- This function is used to choose which feature to use.
-- If the user opts to check when a buffer is added, then the autocmd module will be used
-- else if opts.check_after_minutes is enabled the timer module will be used.
-- If both are disabled, then nothing happen
--
-- @function use_only_one_feature
-- @tparam table|nil opts : The user options to apply to the plugin, it will replace the default options.
-- @see buffer-closer.modules.autocmd.init
-- @see buffer-closer.modules.timer.init
-- @see buffer-closer.modules.option.DEFAULT_OPTIONS
Plugin.use_only_one_feature = function(opts)
  if opts.check_when_buffer_adding then
    autocmd_module.init(opts)
  elseif opts.check_after_minutes.enabled then
    timer_module.init(opts)
  end
end

---
-- Sets up the plugin with the user options.
--
-- This function sets up the buffer-closer plugin with the given options.
--
-- @function setup
-- @usage require('buffer-closer').setup({}) (replace `{}` with your `config` table)
--
-- @tparam table|nil user_opts : The user options to apply to the plugin, it will replace the default options.
--
-- @see buffer-closer.modules.timer.init
-- @see buffer-closer.modules.option.apply_user_options
-- @see use_only_one_feature
Plugin.setup = function(user_opts)
  local options = option_module.apply_user_options(user_opts)
  Plugin.use_only_one_feature(options)
end

return Plugin
