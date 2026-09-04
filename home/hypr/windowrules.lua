--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Satty is a transient editor spawned by the Print-key binds, not a window to
-- tile into the layout. Its own floating-hack option only landed upstream in
-- 0.20.1 and the compositor has the final say regardless, so float it here.
hl.window_rule({
    name   = "float-satty",
    match  = { class = "com.gabm.satty" },

    float  = true,
    center = true,
})

-- Windows spawned by waybar's on-click actions are transient panels, not
-- windows to tile into the layout.
hl.window_rule({
    name   = "float-waybar-popups",
    match  = { class = "^([Bb]top|\\.?blueman-manager(-wrapped)?|org\\.pulseaudio\\.pavucontrol|[Pp]avucontrol)$" },

    float  = true,
    center = true,
})
