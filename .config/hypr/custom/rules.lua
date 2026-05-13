local window_rules = {
	-- Uncomment to apply global transparency to all windows:
	{
		match = {
			class = ".*",
		},
		opacity = "0.89 override 0.89 override",
	},
	-- Enable blur for every window
	{
		match = {
			class = ".*",
		},
		no_blur = false,
	},
	{
		match = {
			class = "vesktop",
		},
		workspace = "special:1",
	},
	{
		match = {
			class = "spotify",
		},
		workspace = "special:4",
	},
}

local workspace_rules = {
	{
		workspace = "s[false]",
		gaps_out = 30,
	},
	{
		workspace = "s[true]",
		gaps_out = 50,
	},
}

for _, rule in ipairs(window_rules) do
	hl.window_rule(rule)
end

for _, rule in ipairs(workspace_rules) do
	hl.workspace_rule(rule)
end
