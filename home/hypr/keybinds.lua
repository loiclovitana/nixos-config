---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("programs")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(programs.terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
-- Lock. Goes through logind rather than calling hyprlock directly, so hypridle
-- and `loginctl lock-session` end up on the same path and never stack lockers.
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(programs.menu))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(programs.clipboard))
hl.bind(mainMod .. " + P", hl.dsp.layout("togglesplit"))    -- dwindle only
-- System monitor, same target as clicking the CPU/RAM/temperature stats in waybar
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(programs.monitor))
hl.bind(mainMod .. " + J", hl.dsp.window.pseudo())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move the focused window with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Groups (tabbed windows)
hl.bind(mainMod .. " + G",         hl.dsp.group.toggle())
hl.bind(mainMod .. " + TAB",       hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + G",  hl.dsp.group.lock_active({ action = "toggle" }))

-- Move windows in/out of a group
hl.bind(mainMod .. " + SHIFT + G",   hl.dsp.window.move({ out_of_group = "" }))
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ into_group = "r" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.move({ into_group = "u" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.move({ into_group = "d" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end


for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", persistent = true })
end
for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", persistent = true })
end

hl.bind(mainMod .. " + page_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + page_down",   hl.dsp.focus({ workspace = "m+1" }))

hl.bind(mainMod .. " + SHIFT + page_up", hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + SHIFT + page_down",   hl.dsp.window.move({ workspace = "m+1" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize the focused window with mainMod + CTRL + arrow keys
-- (relative = true makes x/y deltas instead of absolute target sizes; growing one
-- window shrinks its tiled neighbor, same as dragging a border)
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -20, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }), { repeating = true })

-- Screenshots. grimblast captures and pipes the PNG to satty, which is the
-- editor: annotate, then Ctrl+C for the clipboard or Ctrl+S to write it under
-- ~/Pictures/Screenshots (see satty/config.toml). Escape discards.
-- --freeze only matters for "area": it holds the screen still (via hyprpicker)
-- while the rectangle is dragged, so menus and animations cannot move mid-drag.
hl.bind("Print",               hl.dsp.exec_cmd("grimblast --freeze save area - | satty -f -"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grimblast save active - | satty -f -"))
hl.bind("SHIFT + Print",       hl.dsp.exec_cmd("grimblast save output - | satty -f -"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
