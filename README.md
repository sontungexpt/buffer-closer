# buffer-closer

<!--toc:start-->

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Credits](#credits)
- [Similar Plugins](#similar-plugins)

<!--toc:end-->

## Features

- Automatically close inactive buffers after a period of time in minutes

## Installation

```lua
-- lazy.nvim
{
    'sontungexpt/buffer-closer',
	config = true,
	event = "VeryLazy",
},
```

## Configuration

```lua
-- default values
require("buffer-closer").setup({
  min_remaining_buffers = 2,    -- can not be less than 1
  retirement_minutes = 3,       -- can not be less than 1
  checking_interval_minutes = 1, -- can not be less than 1

  excluded = {
    filetypes = { "lazy", "NvimTree" },
    buftypes = { "terminal", "nofile", "quickfix", "prompt", "help" },
    filenames = {},
  },

  -- it means that a buffer will not be closed if it is opened in a window
  ignore_working_windows = true,
})
```

## Similar Plugins

- [nvim-early-retirement](https://github.com/chrisgrieser/nvim-early-retirement)

## Credits

**Thanks**

Thanks for inspiration from [chrisgrieser](https://github.com/chrisgrieser/nvim-early-retirement)
