local wezterm = require('wezterm')
local keymap = require('keymap')
local smart_splits = require('smart-splits')

local config = {}

-- window
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.show_tab_index_in_tab_bar = false
config.integrated_title_button_style = 'Gnome'

-- font
config.font = wezterm.font('JetBrainsMono NF')
config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font {
      family = 'JetBrainsMono NF',
      weight = 'ExtraBold',
    },
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font {
      family = 'JetBrainsMono NF',
      weight = 'ExtraBold',
      style = 'Italic',
    },
  },
}
config.font_size = 13.0
config.line_height = 1.2
config.freetype_load_flags = 'NO_HINTING'

-- visual
config.color_scheme = 'Tokyo Night Moon'
config.default_cursor_style = 'SteadyBar'
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

keymap.setup(config)
smart_splits.setup(config)

return config
