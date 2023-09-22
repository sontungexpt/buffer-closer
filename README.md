# buffer-closer

<!--toc:start-->

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Credits](#credits)
- [Similar Plugins](#similar-plugins)

<!--toc:end-->

## Features

- Automatically close inactive buffers after a period of time in minutes or when the new buffer is adding

## Installation

```lua
-- lazy.nvim
{
    'sontungexpt/buffer-closer',
	event = "VeryLazy",
},
```

## Configuration

```lua
-- default values
require("buffer-closer").setup({
	min_remaining_buffers = 2, -- can not be less than 1
	retirement_minutes = 3, -- can not be less than 1

	-- feature options

	-- if true then it will check the retired buffers when a new valid buffer is added
	check_when_buffer_adding = true,

	-- if check_when_buffer_add is true,
	-- then this option will be off by default
	check_after_minutes = {
		enabled = false,
		interval_minutes = 1, -- can not be less than 1
	},

	-- end of feature options

	excluded = {
		filetypes = { "lazy", "NvimTree", "mason" },
		buftypes = { "terminal", "nofile", "quickfix", "prompt", "help" },
		filenames = {},
	},

	-- it means that a buffer will not be closed if it is opened in a window
	ignore_working_windows = true,
})
```

## Usage

- This plugin will automatically close inactive buffers after a period of time in minutes or when the new buffer is adding
- If you want to close all inactive buffers immediately, you can use `:CloseRetiredBuffer` command

## Similar Plugins

- [nvim-early-retirement](https://github.com/chrisgrieser/nvim-early-retirement)

## Credits

**Thanks**

Thanks for inspiration from [chrisgrieser](https://github.com/chrisgrieser/nvim-early-retirement)
