local config = require('sessions.config').config
local util = require('sessions.util')

local M = {}

---Returns the global directory path where session files are stored.
---@return string
function M.directory() return vim.fn.stdpath('data') .. '/' .. config.directory end

---Returns the filename of the session for the current working directory.
---@return string
function M.filename()
  local filename = util.get_dir_as_filename(vim.fn.getcwd())
  return filename .. '.session.vim'
end

---Returns the full path of the session file for the current working directory.
function M.filepath() return M.directory() .. '/' .. M.filename() end

---Checks if the session file for the current working directory exists.
function M.exists() return vim.fn.filereadable(M.filepath()) == 1 and true or false end

---Saves the session for the current working directory.
function M.save()
  local dir = M.directory()
  local filepath = M.filepath()

  -- check session directory and create if it doesn't exist
  if
    vim.fn.isdirectory(dir) == 0 -- doesn't exist
      and not vim.fn.mkdir(dir, 'p') -- couldn't create
    or vim.fn.filewritable(dir) ~= 2 -- isn't writable
  then
    util.notify_warn('Failed to create session')
    return
  end

  -- check if session file exists
  if not config.overwrite and M.exists() then
    -- vim.fn.input / vim.ui.input / vim.ui.select
    local input = vim.fn.input('Overwrite existing session? (y/n): ')
    if input ~= 'y' then
      util.notify('No session is saved')
      return
    end
  end

  -- workaround to ignore nvim-tree and outline windows
  --
  -- TODO: Find a better solution
  --
  local sessionoptions = { manipulate = false, value = '' }
  if vim.o.sessionoptions:find('blank') ~= nil then
    -- manipulate vim.opt.sessionoptions
    sessionoptions.manipulate = true
    sessionoptions.value = 'blank'
    vim.cmd('set sessionoptions-=' .. sessionoptions.value)
  end

  -- save session
  -- local ok, error = xpcall(function() vim.cmd('mksession ' .. session_filepath) end, debug.traceback)
  local ok, error = pcall(function() vim.cmd('mksession! ' .. filepath) end)
  if ok then
    util.notify('Session saved')
  else
    vim.notify(error or 'mksession: Failed to save session', vim.log.levels.ERROR)
  end

  -- restore vim.opt.sessionoptions
  if sessionoptions.manipulate then vim.cmd('set sessionoptions=' .. sessionoptions.value) end
end

---Loads the session for the current working directory.
function M.load()
  local filepath = M.filepath()
  if not M.exists() then
    util.notify('No session to load')
    return
  end

  -- load session
  vim.cmd('source ' .. filepath)
end

---Deletes the session for the current working directory.
function M.delete()
  if not M.exists() then
    util.notify('No session to delete')
    return
  end

  local filepath = M.filepath()
  if vim.fn.delete(filepath) == 0 then
    util.notify('Session deleted')
  else
    util.notify_warn('Failed to delete session')
  end
end

---Shows infos about the session for the current working directory and the usage.
function M.info()
  vim.notify(M.exists() and 'A' or 'No' .. ' saved session exists.')
  vim.notify('Usage: :Session [save|load|delete]')
end

return M
