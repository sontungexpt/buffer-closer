# buffer-auto-closing

<!--toc:start-->

- [Installation](#installation)
- [Configuration](#configuration)
- [Credits](#credits)
- [Similar Plugins](#similar-plugins)

<!--toc:end-->

## Installation

```lua
-- lazy.nvim
{
    'sontungexpt/buffer-auto-closing',
	config = true,
	event = "VeryLazy",
},
```

## Configuration

```lua
-- default values
require("buffer-auto-closing").setup({
  min_remaining_bufs = 1,
  retirement_mins = 1,        -- can not be less than 1
  interval_checking_mins = 1, -- can not be less than 1

  excluded = {
	filetypes = { "lazy", "NvimTree" },
	buftypes = { "terminal", "nofile", "quickfix", "prompt", "help" },
	filenames = {},
  },

  -- it means that a buffer will not be closed if it is opened in a window
  ignore_working_window = true,
})
```

## Similar Plugins

- [nvim-early-retirement](https://github.com/chrisgrieser/nvim-early-retirement)

## Credits

**Thanks**

Thanks for inspiration from [chrisgrieser](https://github.com/chrisgrieser/nvim-early-retirement)
