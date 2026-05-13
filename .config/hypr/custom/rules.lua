-- hyprlang noerror false
-- You can put custom rules here
-- Window/layer rules: https://wiki.hyprland.org/Configuring/Window-Rules/
-- Workspace rules: https://wiki.hyprland.org/Configuring/Workspace-Rules/

-- ######## Window rules ########

-- Uncomment to apply global transparency to all windows:
hl.window_rule({
	match = {
		class = ".*",
	},
	opacity = "0.89 override 0.89 override",
})

-- Enable blur for xwayland context menus
-- hl.window_rule( { match = { xwayland = true }, no_blur = true } )

-- Enable blur for every window
hl.window_rule({
	match = {
		class = ".*",
	},
	no_blur = false,
})

hl.workspace_rule({
	workspace = "s[false]",
	gaps_out = 30,
})

hl.workspace_rule({
	workspace = "s[true]",
	gaps_out = 50,
})

hl.window_rule({
	match = {
		class = "vesktop",
	},
	workspace = "special:1",
})

hl.window_rule({
	match = {
		class = "spotify",
	},
	workspace = "special:4",
})
