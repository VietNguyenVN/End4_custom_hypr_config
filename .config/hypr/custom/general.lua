-- hyprlang noerror false
-- Put general config stuff here
-- Here's a list of every variable: https://wiki.hyprland.org/Configuring/Variables/

-- monitor=,addreserved, 0, 0, 0, 0 # Custom reserved area
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = "auto",
	scale = 1,
	transform = 0,
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1200@60",
	position = "1920x0",
	scale = 1,
	mirror = "eDP-1",
})

-- HDMI port: mirror display. To see device name, use `hyprctl monitors`

hl.config({
	general = {
		layout = "scrolling",
	},

	decoration = {
		blur = {
			xray = false,
		},
	},

	input = {
		follow_mouse = 0,
	},

	scrolling = {
		column_width = 1,
		--explicit_column_widths = 0.5, 1.0,
		direction = "up",
	},

	master = {
		new_status = "inherit",
	},
})

-- animation = workspaces, 1, 7, menu_decel, slidevert
