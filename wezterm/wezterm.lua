local wezterm = require('wezterm')
local keymap = require('keymap')
local utils = require('utils')
local smart_splits = require('smart-splits')

---@type Config
local config = {}

-- window
config.window_content_alignment = {
  horizontal = 'Center',
  vertical = 'Center',
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.window_frame = {
  font = wezterm.font_with_fallback({
    'MonaspiceNe NF',
    'Noto Sans Mono CJK SC',
  }),
}

-- tab bar
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.show_tab_index_in_tab_bar = false
config.integrated_title_button_style = 'Gnome'

-- font
config.font = wezterm.font_with_fallback({
  'MonaspiceNe NF',
  'Noto Sans Mono CJK SC',
})
config.font_size = 13.0
config.line_height = 1.2

-- visual
config.color_scheme = 'Tokyo Night Storm'
config.audible_bell = 'Disabled'
config.underline_position = '-2pt'

-- mouse
config.mouse_wheel_scrolls_tabs = false

-- quick select
config.quick_select_alphabet = 'arstqwfpzxcvneioluymdhgjbk'
config.quick_select_remove_styling = true

-- misc
config.canonicalize_pasted_newlines = 'LineFeed'
config.quote_dropped_files = 'Posix'
config.term = 'xterm-direct'

-- some programs (e.g. opencode) clear the title via OSC on exit, which
-- collapses the tab to zero width; fall back to the foreground process name
wezterm.on('format-tab-title', function(tab)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  if not title or #title == 0 then
    local ok, info = pcall(function()
      return wezterm.mux.get_pane(tab.active_pane.pane_id):get_foreground_process_info()
    end)
    if ok and info and info.name and #info.name > 0 then
      title = info.name
    else
      title = 'shell'
    end
  end
  return title
end)

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

wezterm.on('update-status', function(window, pane)
  if keymap.is_visual(window, pane) then
    utils.set_visual(window)
  else
    utils.set_normal(window)
  end
end)

keymap.setup(config)
smart_splits.setup(config)

return config
