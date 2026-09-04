---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
return {
    terminal    = "kitty",
    fileManager = "kitty -e yazi",
    monitor     = "kitty --class btop -e btop",
    browser     = "zen-beta",
    menu        = "rofi -show drun",
    clipboard   = "cliphist list | rofi -dmenu | cliphist decode | wl-copy",
}
