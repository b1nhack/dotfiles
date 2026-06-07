local wezterm = require('wezterm')
local keymap = require('keymap')
local utils = require('utils')
local smart_splits = require('smart-splits')

---@type Config
local config = {}

-- window
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_frame = {
  font = wezterm.font('Monaspace Neon'),
}

-- tab bar
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.show_tab_index_in_tab_bar = false
config.integrated_title_button_style = 'Gnome'

-- font
config.font = wezterm.font('Monaspace Neon')
config.font_size = 13.0
config.line_height = 1.2

-- visual
config.color_scheme = 'Tokyo Night Moon'
config.audible_bell = 'Disabled'

-- keyboard
config.allow_win32_input_mode = false

-- mouse
config.disable_default_mouse_bindings = false
config.mouse_wheel_scrolls_tabs = false

-- quick select
config.quick_select_alphabet = 'arstqwfpzxcvneioluymdhgjbk'
config.quick_select_remove_styling = true

-- misc
config.canonicalize_pasted_newlines = 'LineFeed'
config.quote_dropped_files = 'Posix'

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

wezterm.on('update-status', function(window, pane)
  if keymap.is_copy_mode_select_mode[pane:pane_id()] then
    utils.set_visual(window)
  else
    utils.set_normal(window)
  end
end)

keymap.setup(config)
smart_splits.setup(config)

return config
