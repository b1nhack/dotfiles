local M = {}

---@param window Window
function M.set_normal(window)
  window:set_left_status('NORMAL')
end

---@param window Window
function M.set_visual(window)
  window:set_left_status('VISUAL')
end

return M
