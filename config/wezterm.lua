-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- font
config.font_size = 15
-- config.font = wezterm.font '0xProto Nerd Font'
config.font = wezterm.font_with_fallback({
	'0xProto Nerd Font',
  'FiraCode Nerd Font',
  'Symbols Nerd Font Mono',
})

config.color_scheme = 'Desert (Gogh)'
-- config.color_scheme = 'Desert'

-- bind mouse right-click with Copy & Paste
local act = wezterm.action
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

-- config.window_background_opacity = 0.9
-- config.enable_tab_bar = false

-- Finally, return the configuration to wezterm:
return config
