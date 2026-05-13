-- Q key
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("pkill -9 -f $(hyprctl activewindow -j | jq -r .class)"))

-- E key
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("[float; size 960 600; center] dolphin"))

-- W key
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("firefox --private-window"))

-- function: toggle_special_app
local function toggle_special_app(opts)
	local ws = opts.workspace
	local app_cmd = opts.command
	local class_re = opts.class:lower()

	return function()
		local active_ws = hl.get_active_workspace()

		if active_ws and active_ws.name == ws then
			return
		end

		local target = nil

		for _, win in ipairs(hl.get_windows()) do
			if win.class and win.class:lower():find(class_re, 1, true) then
				target = win
				break
			end
		end

		if not target then
			hl.exec_cmd(app_cmd, {
				workspace = ws,
			})
		else
			if not target.workspace or target.workspace.name ~= ws then
				hl.dispatch(hl.dsp.focus({
					window = target,
				}))

				hl.dispatch(hl.dsp.move({
					workspace = ws,
				}))
			end
		end

		local ws_name = ws:gsub("^special:", "")
		hl.dispatch(hl.dsp.workspace.toggle_special(ws_name))
	end
end

-- O key
hl.unbind("SUPER + O")
hl.bind(
	"SUPER + O",
	toggle_special_app({
		workspace = "special:1",
		command = "vesktop",
		class = "vesktop",
		description = "Vesktop",
	}),
	{
		description = "Vesktop",
	}
)

hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian"), {
	description = "Obsidian",
})

-- A key
hl.unbind("SUPER + A")
hl.bind(
	"SUPER + A",
	toggle_special_app({
		workspace = "special:4",
		command = "spotify-launcher",
		class = "spotify",
		description = "Spotify",
	}),
	{
		description = "Spotify",
	}
)
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
hl.bind("SUPER + ALT + J", hl.dsp.global("quickshell:barToggle"), { description = "Toggle bar" })

-- K key
hl.bind(
	"SUPER + ALT + K",
	hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/toggleclock.sh"),
	{ description = "Toggle clock" }
)

-- L key
hl.unbind("SUPER + L")
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Return/backspace key
-- hl.bind("SUPER + RETURN", hl.dsp.layout("cyclenext"))
-- hl.bind("SUPER + BACKSPACE", hl.dsp.layout("cyclenext prev"))

-- Miscellaneous
hl.unbind("CTRL + SHIFT + ESCAPE")
hl.bind("CTRL + SHIFT + ESCAPE", function()
	local WS_NAME = "3"
	local WS = "special:" .. WS_NAME
	local TITLE = "btop"

	local active_special = hl.get_active_special_workspace()
	if active_special and active_special.name == WS then
		hl.dispatch(hl.dsp.workspace.toggle_special(WS_NAME))
		return
	end

	local found = false
	for _, win in ipairs(hl.get_windows()) do
		if win.title == TITLE then
			found = true
			break
		end
	end

	if not found then
		hl.exec_cmd("kitty btop", { workspace = WS })
	end

	hl.dispatch(hl.dsp.workspace.toggle_special(WS_NAME))
end, { description = "Btop" })
hl.bind("CTRL + ALT + BACKSPACE", hl.dsp.global("quickshell:sessionToggle"))

-- \ key
hl.bind("SUPER + BACKSLASH", function()
	local handle = io.popen("pgrep -x fcitx5 >/dev/null && echo 1 || echo 0")
	if not handle then
		return
	end
	local result = handle:read("*a")
	handle:close()
	local running = result:match("1")
	if running then
		hl.exec_cmd("pkill -x fcitx5")
	else
		hl.exec_cmd("fcitx5 -d")
	end
end, { description = "Toggle fcitx5" })

hl.bind(
	"SUPER + ALT + BACKSLASH",
	hl.dsp.exec_cmd(
		'kitty --class neo neo -m "Those who worship the terminal never fear the system. They are the system." --defaultbg --speed=12 --density=10 --lingerms=1,1 --rippct=0'
	)
)

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

-- Space key
hl.unbind("SUPER + ALT + SPACE")
local TMP_PREFIX = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/hypr_float_cycle_state-"

local SIZES = {
	{ 960, 600 }, -- small
	{ 1280, 800 }, -- medium
	{ 1600, 1000 }, -- large
}

local function state_path_for(addr)
	return TMP_PREFIX .. addr:gsub("[^%w%-%._]", "_")
end

local function read_state(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end

	local data = f:read("*a")
	f:close()

	local n = tonumber((data or ""):match("^(%d+)%s*$"))
	return n
end

local function write_state(path, idx)
	local f, err = io.open(path, "w")
	if not f then
		error(err)
	end

	f:write(tostring(idx))
	f:close()
end

hl.bind("SUPER + ALT + SPACE", function()
	local win = hl.get_active_window()
	if not win or not win.address then
		return
	end

	local addr = win.address
	local state_file = state_path_for(addr)

	-- `win.floating` should be present on window objects; if not, fall back to first press behavior.
	local is_floating = win.floating == true

	if not is_floating then
		hl.dispatch(hl.dsp.window.float({ action = "toggle", window = win }))

		local w, h = table.unpack(SIZES[1])
		hl.dispatch(hl.dsp.window.resize({
			x = w,
			y = h,
			relative = false,
			window = win,
		}))
		hl.dispatch(hl.dsp.window.center({ window = win }))

		write_state(state_file, 0)
		return
	end

	local current_index = read_state(state_file) or 0
	local next_index = current_index + 1

	if next_index >= #SIZES then
		hl.dispatch(hl.dsp.window.float({ action = "toggle", window = win }))
		os.remove(state_file)
		return
	end

	local w, h = table.unpack(SIZES[next_index + 1])
	hl.dispatch(hl.dsp.window.resize({
		x = w,
		y = h,
		relative = false,
		window = win,
	}))
	hl.dispatch(hl.dsp.window.center({ window = win }))

	write_state(state_file, next_index)
end)

-- Copilot key
hl.config({
	input = {
		kb_options = "fkeys:basic_13-24",
	},
})

local Copilot = "SUPER + SHIFT + F23"

local function cycle_layout(layouts)
	local current = hl.get_config("general.layout")
	local current_name = type(current) == "table" and current.name or current

	local next_index = 1
	for i, layout in ipairs(layouts) do
		if layout == current_name then
			next_index = (i % #layouts) + 1
			break
		end
	end

	hl.config({
		general = {
			layout = layouts[next_index],
		},
	})
end

hl.bind(Copilot, function()
	cycle_layout({ "scrolling", "monocle" })
end, { description = "!CYCLE LAYOUT" })

hl.bind("CTRL + " .. Copilot, function()
	cycle_layout({ "dwindle", "master" })
end, { description = "!CYCLE LAYOUT (TILED)" })

local function current_layout()
	local current = hl.get_config("general.layout")
	return type(current) == "table" and current.name or current
end

-- ######### LAYOUTS #########

local function layout_bind(layout_name, cmd)
	return function()
		if current_layout() ~= layout_name then
			return
		end

		hl.dispatch(hl.dsp.layout(cmd))
	end
end

-- DWINDLE LAYOUT
hl.unbind("SUPER + J")
hl.bind("SUPER + J", layout_bind("dwindle", "togglesplit"), { description = "[d] Togglesplit" })

-- SCROLLING LAYOUT
-- Keyboard
hl.unbind("SUPER + Period")
hl.unbind("SUPER + Comma")
hl.bind("SUPER + Period", layout_bind("scrolling", "focus u"), { description = "[s] Move view (u)" })
hl.bind("SUPER + Comma", layout_bind("scrolling", "focus d"), { description = "[s] Move view (d)" })
hl.bind(
	"SUPER + SHIFT + Period",
	layout_bind("scrolling", "colresize +0.1"),
	{ description = "[s] Change size (+0.1)" }
)
hl.bind("SUPER + SHIFT + Comma", layout_bind("scrolling", "colresize -0.1"), { description = "[s] Change size (-0.1)" })
hl.bind("SUPER + ALT + Comma", layout_bind("scrolling", "swapcol l"), { description = "[s] Swap row [u]" })
hl.bind("SUPER + ALT + Period", layout_bind("scrolling", "swapcol r"), { description = "[s] Swap row [d]" })
-- Mouse
hl.unbind("SUPER + mouse_up")
hl.unbind("SUPER + mouse_down")
hl.bind("SUPER + mouse_up", layout_bind("scrolling", "focus u"), { description = "[s] Move view (u)" })
hl.bind("SUPER + mouse_down", layout_bind("scrolling", "focus d"), { description = "[s] Move view (d)" })
hl.unbind("SUPER + SHIFT + mouse_up")
hl.unbind("SUPER + SHIFT + mouse_down")
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.focus({ workspace = "r-1" }))
hl.unbind("SUPER + ALT + mouse_up")
hl.unbind("SUPER + ALT + mouse_down")
hl.bind("SUPER + ALT + mouse_up", layout_bind("scrolling", "swapcol l"), { description = "[s] Swap row [u]" })
hl.bind("SUPER + ALT + mouse_down", layout_bind("scrolling", "swapcol r"), { description = "[s] Swap row [d]" })
hl.unbind("CTRL + SUPER + mouse_up")
hl.unbind("CTRL + SUPER + mouse_down")
hl.bind(
	"CTRL + SUPER + mouse_up",
	layout_bind("scrolling", "colresize -0.1"),
	{ description = "[s] Change size (-0.1)" }
)
hl.bind(
	"CTRL + SUPER + mouse_down",
	layout_bind("scrolling", "colresize +0.1"),
	{ description = "[s] Change size (+0.1)" }
)

-- MASTER LAYOUT
hl.bind("SUPER + J", layout_bind("master", "swapwithmaster"), { description = "[m] Swap master" })
hl.bind("SUPER + SHIFT + J", layout_bind("master", "addmaster"), { description = "[m] Add master" })
hl.bind("SUPER + SHIFT + K", layout_bind("master", "removemaster"), { description = "[m] Remove master" })
hl.bind("SUPER + COMMA", layout_bind("master", "cycleprev noloop"), { description = "[m] Cycle prev" })
hl.bind("SUPER + PERIOD", layout_bind("master", "cyclenext noloop"), { description = "[m] Cycle next" })
hl.bind("SUPER + SHIFT + COMMA", layout_bind("master", "swapprev noloop"), { description = "[m] Swap prev" })
hl.bind("SUPER + SHIFT + PERIOD", layout_bind("master", "swapnext noloop"), { description = "[m] Swap next" })
hl.bind("SUPER + ALT + COMMA", layout_bind("master", "rollnext"), { description = "[m] Roll next" })
hl.bind("SUPER + ALT + PERIOD", layout_bind("master", "rollprev"), { description = "[m] Roll prev" })
hl.bind("SUPER + SEMICOLON", layout_bind("master", "mfact -0.05"))
hl.bind("SUPER + APOSTROPHE", layout_bind("master", "mfact +0.05"))
hl.bind("SUPER + SPACE", layout_bind("master", "orientationcycle"), { description = "[m] Cycle orientation" })

-- MONOCLE LAYOUT
hl.bind("ALT + TAB", layout_bind("monocle", "cyclenext"))
