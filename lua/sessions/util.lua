local M = {}

---Returns a directory path as a filename.
--
-- Example:
-- - `/Kong/foo/bar` -> `Kong_foo_bar`
-- - `C:\Kong\foo\bar` -> `C_Kong_foo_bar`
--
---@param dir string
---@return string
function M.get_dir_as_filename(dir)
  -- trim leading and trailing slashes (back slashes)
  local filename = dir:gsub('^[/\\]+', ''):gsub('[/\\]+$', '')
  -- replace `/:\` (also multiple) with an underscore
  filename = filename:gsub('[:/\\]+', '_')
  return filename
end

---Displays a notification to the user.
---@param message string
function M.notify(message) vim.notify(message, vim.log.levels.INFO) end

---Displays a warning notification to the user.
---@param message string
function M.notify_warn(message)
  vim.notify(message, vim.log.levels.WARN)
  vim.notify('Run `:checkhealth sessions` to check the health of the plugin.')
end

return M
