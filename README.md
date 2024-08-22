# nvim-sessions

A simple session management plugin for Neovim.
It uses `:mksession` to save and `:source` to load sessions.

> [!WARNING]
> This plugin is based on my personal needs. Work in progress. 🚀

## Features

- Uses one session file per working directory
- Session files are stored global in `vim.fn.stdpath('data')`
- Sessions can be saved, loaded and deleted

## Requirements

- Neovim >= 0.10

## Installation

### [lazy.nvim]

[lazy.nvim]: https://github.com/folke/lazy.nvim

```lua
return {
  'tigion/nvim-sessions',
  keys = {
    { '<Leader>ws', '<Cmd>Session save<CR>', desc = 'Save session (cwd)' },
    { '<Leader>wl', '<Cmd>Session load<CR>', desc = 'Load session (cwd)' },
  },
  opts = {},
}
```

For other plugin manager, call the setup function
`require('sessions').setup({ ... })` directly.

### Default Options

Currently available settings for the user:

```lua
{
  -- The name of the subdirectory in `vim.fn.stdpath('data')`
  -- where the sessions are saved.
  -- If it does not exist, it will be created.
  directory = 'sessions', ---@type string

  -- Overwrites existing session files without confirmation.
  overwrite = true, ---@type boolean
}
```

## Usage

| Command           | Description                                                 |
| ----------------- | ----------------------------------------------------------- |
| `:Session`        | Shows information about the current session                 |
| `:Session save`   | Saves the current session for the current working directory |
| `:Session load`   | Loads the session for the current working directory         |
| `:Session delete` | Deletes the session for the current working directory       |

Run `:checkhealth sessions` to check the health of the plugin.

## TODO

- [x] Move simple session management from tigion.core.util.session to a plugin.
- [x] Update readme
