-- local config = require('sessions.config')
local session = require('sessions.session')

local M = {}

-- M.setup = config.setup
-- M.setup = require('sessions.config').setup
function M.setup(opts)
  -- check neovim version
  if vim.fn.has('nvim-0.11') == 0 then
    local msg = 'nvim-sessions requires Neovim >= 0.10'
    vim.notify(msg, vim.log.levels.ERROR, { title = 'nvim-session' })
    return
  end

  -- setup config
  require('sessions.config').setup(opts)

  -- create `Session` command
  --
  -- NOTE: - `:h nvim_create_user_command`
  --       - https://tui.ninja/neovim/customizing/user_commands/creating/
  --
  vim.api.nvim_create_user_command('Session', function(input)
    if input.args == '' then
      if session.exists() then
        vim.notify('A saved session exists.')
      else
        vim.notify('No saved session exists.')
      end
      vim.notify('Usage: :Session [save|load|delete]')
    elseif input.args == 'save' then
      session.save()
    elseif input.args == 'load' then
      session.load()
    elseif input.args == 'delete' then
      session.delete()
    else
      vim.notify('Usage: :Session [save|load|delete]')
    end
  end, {
    nargs = '?',
    complete = function() return { 'save', 'load', 'delete' } end,
    desc = 'Session [save|load|delete]',
  })
end

M.exists = session.exists

return M
