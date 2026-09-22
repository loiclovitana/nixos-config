-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_THEME", "catppuccin-mocha-red-cursors")
hl.env("XCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-red-cursors")
hl.env("HYPRCURSOR_SIZE", "32")

-- nvidia-vaapi-driver only works outside X with the direct backend. Inert
-- unless a process is started with LIBVA_DRIVER_NAME=nvidia under offload.
hl.env("NVD_BACKEND", "direct")
