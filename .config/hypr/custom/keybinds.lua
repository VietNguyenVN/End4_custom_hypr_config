-- Q key
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("pkill -9 -f $(hyprctl activewindow -j | jq -r .class)"))

-- E key
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("[float; size 960 600; center] dolphin"))

-- O Key
hl.unbind("SUPER + O")
hl.bind("SUPER + O", function()
	local WS = "special:1"
	local APP_CMD = "vesktop"
	local CLASS_RE = "vesktop"

	local active_ws = hl.get_active_workspace()
	if active_ws and active_ws.name == WS then
		return
	end

	local target = nil
	for _, win in ipairs(hl.get_windows()) do
		if win.class and win.class:lower():find(CLASS_RE, 1, true) then
			target = win
			break
		end
	end

	if not target then
		hl.exec_cmd(APP_CMD, { workspace = WS })
	else
		if not target.workspace or target.workspace.name ~= WS then
			hl.dispatch(hl.dsp.focus({ window = target }))
			hl.dispatch(hl.dsp.move({ workspace = WS }))
		end
	end

	hl.dispatch(hl.dsp.workspace.toggle_special("1"))
end, { description = "Vesktop" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian"), { description = "Obsidian" })

-- W key
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("firefox --private-window")) -- [hidden]

-- A key
hl.unbind("SUPER + A")
hl.bind("SUPER + A", function()
	local WS = "special:4"
	local APP_CMD = "spotify-launcher"
	local CLASS_RE = "spotify"

	local active_ws = hl.get_active_workspace()
	if active_ws and active_ws.name == WS then
		return
	end

	local target = nil
	for _, win in ipairs(hl.get_windows()) do
		if win.class and win.class:lower():find(CLASS_RE, 1, true) then
			target = win
			break
		end
	end

	if not target then
		hl.exec_cmd(APP_CMD, { workspace = WS })
	else
		if not target.workspace or target.workspace.name ~= WS then
			hl.dispatch(hl.dsp.focus({ window = target }))
			hl.dispatch(hl.dsp.move({ workspace = WS }))
		end
	end

	hl.dispatch(hl.dsp.workspace.toggle_special("4"))
end, {
	description = "Spotify",
})

-- X key
hl.unbind("SUPER + X")
hl.bind("SUPER + X", hl.dsp.exec_cmd("kitty nvim"))

-- C key
hl.unbind("SUPER + C")
hl.bind("SUPER + C", hl.dsp.exec_cmd("papers"), { description = "Document Viewer" })

-- U key
hl.bind(
	"SUPER + U",
	hl.dsp.exec_cmd("kitty ~/.config/hypr/custom/scripts/printdotscommits.sh"),
	{ description = "Check dots-hyprland commits" }
)
hl.bind(
	"SUPER + SHIFT + U",
	hl.dsp.exec_cmd("kitty ~/.config/hypr/custom/scripts/updatedots.sh"),
	{ description = "Update dots-hyprland" }
)

-- Y key
hl.bind(
	"SUPER + Y",
	hl.dsp.exec_cmd("kitty ~/.config/hypr/custom/scripts/archstatusprint.sh"),
	{ description = "Check Archstatus" }
)
hl.bind(
	"SUPER + SHIFT + Y",
	hl.dsp.exec_cmd("kitty ~/.config/hypr/custom/scripts/updatesystem.sh"),
	{ description = "Update system" }
)

-- D key
hl.bind(
	"SUPER + ALT + D",
	hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/toggledock.sh"),
	{ description = "Toggle dock" }
)

-- P key
local GENERAL_LUA = os.getenv("HOME") .. "/.config/hypr/custom/general.lua"
local function read_file(path)
	local f, err = io.open(path, "r")
	if not f then
		error(err)
	end
	local data = f:read("*a")
	f:close()
	return data
end

local function write_file(path, data)
	local f, err = io.open(path, "w")
	if not f then
		error(err)
	end
	f:write(data)
	f:close()
end
local function notify(msg)
	hl.exec_cmd(string.format('notify-send "Hyprland Refresh Rate" "%s"', msg))
end
local function toggle_refresh()
	local src = read_file(GENERAL_LUA)
	-- Match any: refresh = 120
	local current = tonumber(src:match("refresh%s*=%s*(%d+)"))
	if not current then
		notify("Could not find refresh value")
		return
	end
	local next_rate = (current == 120) and 60 or 120
	-- Replace first refresh assignment only
	local updated, n = src:gsub("refresh%s*=%s*%d+", "refresh = " .. next_rate, 1)
	if n == 0 then
		notify("Failed to update refresh value")
		return
	end
	write_file(GENERAL_LUA, updated)
	-- Reload Hyprland config
	hl.exec_cmd("hyprctl reload")
	notify(string.format("eDP-1 switched to %dHz", next_rate))
end
hl.bind("SUPER + ALT + P", toggle_refresh, { description = "Change refresh rate" })

-- H key
-- hl.bind("SUPER + ALT + H", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/showdesktop.sh")) -- Show desktop

-- J key
hl.unbind("SUPER + J")
hl.bind("SUPER + J", hl.dsp.layout("togglesplit")) -- [hidden]
hl.bind("SUPER + ALT + J", hl.dsp.global("quickshell:barToggle")) -- Toggle bar

-- K key
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/toggleclock.sh")) -- Toggle clock

-- L key
hl.unbind("SUPER + L")
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("loginctl lock-session")) -- [hidden]

-- Return/backspace key
-- hl.bind("SUPER + RETURN", hl.dsp.layout("cyclenext")) -- [hidden]
-- hl.bind("SUPER + BACKSPACE", hl.dsp.layout("cyclenext prev")) -- [hidden]
-- #/# bind = Super, Enter/backspace,, # Window cycle
hl.unbind("CTRL + SHIFT + ESCAPE")
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/btop_special.sh")) -- [hidden]
hl.bind("CTRL + ALT + BACKSPACE", hl.dsp.global("quickshell:sessionToggle")) -- [hidden]

-- \ key
hl.bind("SUPER + BACKSLASH", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/togglefcitx5.sh")) -- [hidden]
--/# bind = Super, \,, # Toggle fcitx5

hl.bind(
	"SUPER + ALT + BACKSLASH",
	hl.dsp.exec_cmd(
		'kitty --class neo neo -m "Those who worship the terminal never fear the system. They are the system." --defaultbg --speed=12 --density=10 --lingerms=1,1 --rippct=0'
	)
) -- [hidden]

hl.window_rule({
	match = {
		class = "neo",
	},
	fullscreen = true,
})

hl.bind("SUPER + SHIFT + BACKSLASH", hl.dsp.exec_cmd("kitty --class unimatrix unimatrix")) -- [hidden]

hl.window_rule({
	match = {
		class = "unimatrix",
	},
	fullscreen = true,
})

hl.bind("CTRL + SUPER + BACKSLASH", hl.dsp.exec_cmd("kitty --class vis vis")) -- [hidden]

hl.window_rule({
	match = {
		class = "vis",
	},
	fullscreen = true,
})

--/# bind = Super+Ctrl/Shift/Alt, \,, # Screensaver

-- Space key
hl.unbind("SUPER + ALT + SPACE")
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/togglefloating.sh")) -- [hidden]

-- Copilot key
hl.config({
	input = {
		kb_options = "fkeys:basic_13-24",
	},
})

local Copilot = "SUPER + SHIFT + F23"

hl.bind(Copilot, hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/togglelayout.sh")) -- [hidden]
hl.bind("CTRL + " .. Copilot, hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/togglelayout_tiled.sh")) -- [hidden]

--/# bind = Ø/Ctrl, Copilot,, # !CYCLE LAYOUT

-- ##! Scrolling layout
-- Comma/Period
hl.unbind("SUPER + PERIOD")

hl.bind("SUPER + PERIOD", hl.dsp.layout("focus u")) -- [hidden]
hl.bind("SUPER + COMMA", hl.dsp.layout("focus d")) -- [hidden]

--/# bind = Super, cm/pr,, # Move view

hl.bind("SUPER + SHIFT + PERIOD", hl.dsp.layout("colresize +0.1")) -- [hidden]
hl.bind("SUPER + SHIFT + COMMA", hl.dsp.layout("colresize -0.1")) -- [hidden]

--/# bind = Super+Shift, cm/pr,, # Change size

hl.bind("SUPER + ALT + PERIOD", hl.dsp.layout("swapcol r")) -- [hidden]
hl.bind("SUPER + ALT + COMMA", hl.dsp.layout("swapcol l")) -- [hidden]

--/# bind = Super+Alt, cm/pr,, # Swap column

hl.unbind("SUPER + RETURN")
hl.bind("SUPER + RETURN", hl.dsp.layout("colresize +conf")) -- Resize to halfscreen

-- ## New config ##
-- Mouse
hl.unbind("SUPER + mouse_up")
hl.unbind("SUPER + mouse_down")

hl.bind("SUPER + mouse_up", hl.dsp.layout("focus u")) -- [hidden]
hl.bind("SUPER + mouse_down", hl.dsp.layout("focus d")) -- [hidden]

-- #/# bind = Super, Scroll ↑/↓,, # [hidden] Move view

hl.unbind("SUPER + SHIFT + mouse_up")
hl.unbind("SUPER + SHIFT + mouse_down")

hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.focus({ workspace = "r+1" })) -- [hidden]
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.focus({ workspace = "r-1" })) -- [hidden]

-- #/# bind = Super+Shift, Scroll ↑/↓,, # [hidden] Change workspace

hl.unbind("SUPER + ALT + mouse_up")
hl.unbind("SUPER + ALT + mouse_down")

hl.bind("SUPER + ALT + mouse_up", hl.dsp.layout("swapcol l")) -- [hidden]
hl.bind("SUPER + ALT + mouse_down", hl.dsp.layout("swapcol r")) -- [hidden]

-- #/# bind = Super+Alt, Scroll ↑/↓,, # [hidden] Swap column

hl.unbind("CTRL + SUPER + mouse_up")
hl.unbind("CTRL + SUPER + mouse_down")

hl.bind("CTRL + SUPER + mouse_up", hl.dsp.layout("colresize -0.1")) -- [hidden]
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.layout("colresize +0.1")) -- [hidden]

-- #/# bind = Ctrl+Super, Scroll ↑/↓,, # [hidden] Change size

-- ##! Master layout
hl.bind("SUPER + J", hl.dsp.layout("swapwithmaster")) -- [hidden]
--/# bind = Super, J,, # Swap master

hl.bind("SUPER + SHIFT + J", hl.dsp.layout("addmaster")) -- [hidden]
hl.bind("SUPER + SHIFT + K", hl.dsp.layout("removemaster")) -- [hidden]

--/# bind = Super+Shift, J/K,, # Add to/Remove from master

hl.bind("SUPER + COMMA", hl.dsp.layout("cycleprev noloop")) -- [hidden]
hl.bind("SUPER + PERIOD", hl.dsp.layout("cyclenext noloop")) -- [hidden]

--/# bind = Super, cm/pr,, # Cycle previous/next

hl.bind("SUPER + SHIFT + COMMA", hl.dsp.layout("swapprev noloop")) -- [hidden]
hl.bind("SUPER + SHIFT + PERIOD", hl.dsp.layout("swapnext noloop")) -- [hidden]

--/# bind = Super+Shift, cm/pr,, # Swap previous/next

hl.bind("SUPER + ALT + COMMA", hl.dsp.layout("rollnext")) -- [hidden]
hl.bind("SUPER + ALT + PERIOD", hl.dsp.layout("rollprev")) -- [hidden]

--/# bind = Super+Alt, cm/pr,, # Roll previous/next

hl.bind("SUPER + SEMICOLON", hl.dsp.layout("mfact -0.05")) -- [hidden]
hl.bind("SUPER + APOSTROPHE", hl.dsp.layout("mfact +0.05")) -- [hidden]

hl.bind("SUPER + SPACE", hl.dsp.layout("orientationcycle")) -- Cycle orientations

-- Monocle layout
-- hl.bind("ALT + TAB", hl.dsp.layout("cyclenext")) -- [hidden]
