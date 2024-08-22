-- local config = require('sessions.config')
local session = require('sessions.session')

local M = {}

-- M.exists = function() end
-- M.save = function() end
-- M.load = function() end
-- M.delete = function() end

-- M.setup = config.setup
-- M.setup = require('sessions.config').setup
function M.setup(opts)
  if vim.fn.has('nvim-0.10') == 0 then
    local msg = 'nvim-sessions requires Neovim >= 0.10'
    vim.notify(msg, vim.log.levels.ERROR, { title = 'nvim-session' })
    return
  end

  require('sessions.config').setup(opts)

  -- M.exists = session.exists
  -- M.save = session.save
  -- M.load = session.load
  -- M.delete = session.delete
end

M.exists = session.exists
M.save = session.save
M.load = session.load
M.delete = session.delete

return M
