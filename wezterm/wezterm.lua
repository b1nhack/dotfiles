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

-- Programs leave the OSC title behind on exit (neomutt) or clear it
-- (opencode), so the pane title is only meaningful while that program is
-- the foreground process. When the shell is in the foreground, show the
-- shell name instead; otherwise show the program's own title, falling
-- back to its process name.
local SHELL_NAMES = {
  zsh = true,
  bash = true,
  fish = true,
  sh = true,
  dash = true,
  ksh = true,
  tcsh = true,
}

wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane

  -- an explicitly set tab title always wins
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title
  end

  local ok, info = pcall(function()
    return wezterm.mux.get_pane(pane.pane_id):get_foreground_process_info()
  end)
  local fg_name = (ok and info and info.name) or ''

  if SHELL_NAMES[fg_name] then
    -- at the prompt: any OSC title here is stale, show the shell name
    return fg_name
  end
  if pane.title and #pane.title > 0 then
    -- a program is in the foreground: trust its own title
    return pane.title
  end
  return (fg_name ~= '' and fg_name) or 'shell'
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
