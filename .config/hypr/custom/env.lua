-- hyprlang noerror false
-- You can put extra environment variables here
-- https://wiki.hyprland.org/Configuring/Environment-variables/

-- ######### Input method ##########
-- See https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland

-- hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission({ binary = "fcitx5-lotus-server", type = "keyboard", mode = "allow" })

-- ######## Wayland #########
-- Tearing
-- hl.env("WLR_DRM_NO_ATOMIC", "1")
-- ?
-- hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- ######## EDITOR #########
-- https://wiki.archlinux.org/title/Category:Text_editors
-- for example: vi nano nvim ...

hl.env("EDITOR", "nvim")

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
