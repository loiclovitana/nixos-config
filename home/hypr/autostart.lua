-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function ()
--   local programs = require("programs")
--   hl.exec_cmd(programs.terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.on("hyprland.start", function ()
  hl.exec_cmd("waybar")
  hl.exec_cmd("dunst")
  -- Per-workspace wallpapers: awww draws them, the daemon follows
  -- workspace changes and tells it what to show. See home/scripts/.
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("hypr-wallpaper-daemon")
  -- Idle daemon: dim, lock, sleep. See hypridle.conf.
  hl.exec_cmd("hypridle")
  -- cliphist watchers are systemd user services (see home/home-manager.nix);
  -- starting them here races the wlr-data-control interface and they die.
end)
