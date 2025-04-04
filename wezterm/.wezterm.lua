local wezterm = require("wezterm")
local config = {}
local act = wezterm.action

-- font
config.font = wezterm.font("Hack Nerd Font Propo", {})
config.font_size = 16

-- scrollback
config.scrollback_lines = 1000000

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha (Gogh)"
	else
		return "Catppuccin Latte (Gogh)"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

wezterm.on("window-config-reloaded", function(window, _)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local overrides_appearance = mode_overrides(appearance)
	local scheme = overrides_appearance.color_scheme
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		-- overrides.colors = {
		-- 	background = overrides_appearance.background,
		-- }
		window:set_config_overrides(overrides)
	end
end)

--/ dynamic color scheme switching
config.window_decorations = "RESIZE" -- "TITLE | RESIZE"
config.enable_tab_bar = false
config.use_fancy_tab_bar = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	-- This will create a new split and run the `top` program inside it
	{
		key = '"',
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "t",
		mods = "SHIFT|ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{ key = "F9", mods = "", action = wezterm.action.ShowTabNavigator },
}

-- config.modifier_keys = {
--   OPT = "Meta"
-- }
-- config.colors = {}

-- background blur
config.window_background_opacity = 0.90
config.macos_window_background_blur = 10

-- dont confirm on exit
config.window_close_confirmation = "NeverPrompt"

return config
