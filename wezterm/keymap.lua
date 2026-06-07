local M = {}

local wezterm = require('wezterm')
local act = wezterm.action
local utils = require('utils')

M.is_copy_mode_select_mode = {}

local function enter_copy_mode_select_mode(mode)
  return wezterm.action_callback(function(window, pane)
    window:perform_action(act.CopyMode { SetSelectionMode = mode }, pane)
    M.is_copy_mode_select_mode[pane:pane_id()] = true
    utils.set_visual(window)
  end)
end

---@param config Config
function M.setup(config)
  config.disable_default_key_bindings = true
  config.keys = {
    -- panel
    { key = 'u', mods = 'SUPER', action = act.SplitPane { direction = 'Up' } },
    { key = 'e', mods = 'SUPER', action = act.SplitPane { direction = 'Down' } },
    { key = 'n', mods = 'SUPER', action = act.SplitPane { direction = 'Left' } },
    { key = 'i', mods = 'SUPER', action = act.SplitPane { direction = 'Right' } },

    { key = 'u', mods = 'ALT', action = act.ActivatePaneDirection('Up') },
    { key = 'e', mods = 'ALT', action = act.ActivatePaneDirection('Down') },
    { key = 'n', mods = 'ALT', action = act.ActivatePaneDirection('Left') },
    { key = 'i', mods = 'ALT', action = act.ActivatePaneDirection('Right') },

    { key = 'UpArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'DownArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'LeftArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'RightArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },

    { key = 'Enter', mods = 'ALT', action = act.TogglePaneZoomState },
    { key = 'k', mods = 'SUPER', action = act.CloseCurrentPane { confirm = true } },

    -- tab
    {
      key = 't',
      mods = 'SUPER',
      action = act.SpawnCommandInNewTab { domain = 'CurrentPaneDomain', cwd = '~' },
    },

    { key = '[', mods = 'ALT', action = act.ActivateTabRelativeNoWrap(-1) },
    { key = ']', mods = 'ALT', action = act.ActivateTabRelativeNoWrap(1) },

    { key = '{', mods = 'ALT|SHIFT', action = act.MoveTabRelative(-1) },
    { key = '}', mods = 'ALT|SHIFT', action = act.MoveTabRelative(1) },

    --window
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },

    -- clipboard
    {
      key = 'C',
      mods = 'CTRL|SHIFT',
      action = act.Multiple { act.CopyTo('Clipboard'), act.ClearSelection },
    },
    { key = 'V', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },

    -- quick select
    { key = 'Space', mods = 'CTRL|SHIFT', action = act.QuickSelect },

    -- copy mode
    { key = 'X', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

    -- misc
    { key = 'f', mods = 'SUPER', action = act.Search { CaseSensitiveString = '' } },
    { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
    {
      key = 'r',
      mods = 'SUPER',
      action = act.Multiple {
        -- when in viewport, sendKey not working
        act.ScrollToBottom,
        act.SendKey { key = 'l', mods = 'CTRL' },
      },
    },

    -- fix zsh C-i
    { key = 'i', mods = 'CTRL', action = act.SendString('\x1b[105;5u') },
  }

  config.key_tables = {
    search_mode = {
      { key = 'Enter', mods = 'SHIFT', action = act.CopyMode('PriorMatch') },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode('NextMatch') },
      { key = 'r', mods = 'CTRL', action = act.CopyMode('CycleMatchType') },
      { key = 'u', mods = 'CTRL', action = act.CopyMode('ClearPattern') },
    },

    copy_mode = {
      {
        key = 'Escape',
        mods = 'NONE',
        action = wezterm.action_callback(function(window, pane)
          local pane_id = pane:pane_id()
          if M.is_copy_mode_select_mode[pane_id] then
            window:perform_action(
              act.Multiple { act.ClearSelection, act.CopyMode('ClearSelectionMode') },
              pane
            )
            M.is_copy_mode_select_mode[pane_id] = false
            utils.set_normal(window)
          else
            window:perform_action(
              act.Multiple { act.ScrollToBottom, act.ClearSelection, act.CopyMode('Close') },
              pane
            )
          end
        end),
      },
      { key = 'h', mods = 'NONE', action = act.CopyMode('MoveForwardWordEnd') },
      { key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },
      { key = 'N', mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'I', mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },
      { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
      {
        key = 'u',
        mods = 'SHIFT',
        action = act.Multiple {
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
          act.CopyMode('MoveUp'),
        },
      },
      {
        key = 'e',
        mods = 'SHIFT',
        action = act.Multiple {
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
          act.CopyMode('MoveDown'),
        },
      },
      { key = 'n', mods = 'NONE', action = act.CopyMode('MoveLeft') },
      { key = 'e', mods = 'NONE', action = act.CopyMode('MoveDown') },
      { key = 'u', mods = 'NONE', action = act.CopyMode('MoveUp') },
      { key = 'i', mods = 'NONE', action = act.CopyMode('MoveRight') },

      -- select mode
      {
        key = 'v',
        mods = 'NONE',
        action = enter_copy_mode_select_mode('Cell'),
      },
      {
        key = 'v',
        mods = 'CTRL',
        action = enter_copy_mode_select_mode('Block'),
      },
      {
        key = 'V',
        mods = 'SHIFT',
        action = enter_copy_mode_select_mode('Line'),
      },

      {
        key = 'y',
        mods = 'NONE',
        action = act.Multiple {
          act.CopyTo('ClipboardAndPrimarySelection'),
          act.ScrollToBottom,
          act.ClearSelection,
          act.CopyMode('Close'),
        },
      },
    },
  }
end

return M
