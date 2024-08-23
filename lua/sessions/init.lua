-- local config = require('sessions.config')
local session = require('sessions.session')

local M = {}

-- M.setup = config.setup
-- M.setup = require('sessions.config').setup
function M.setup(opts)
  -- check neovim version
  if vim.fn.has('nvim-0.10') == 0 then
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
      vim.notify(session.exists() and 'A' or 'No' .. ' saved session exists.')
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
    complete = function(ArgLead)
      local choices = { 'save', 'load', 'delete' }
      table.sort(choices)
      if ArgLead == '' then return choices end
      return vim.tbl_filter(function(choice) return string.find(choice, ArgLead) == 1 end, choices)
    end,
    desc = 'Session [save|load|delete]',
  })
end

M.exists = session.exists

return M
