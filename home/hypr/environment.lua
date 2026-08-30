-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ssh-agent runs as a systemd user service (modules/ssh.nix) and always binds
-- $XDG_RUNTIME_DIR/ssh-agent. greetd launches Hyprland through uwsm, which does
-- not source /etc/profile, so the variable NixOS exports there never reaches
-- GUI children -- only login shells. Setting it here covers both.
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent")

-- Hybrid graphics (see modules/graphics.nix). Hyprland must pick the AMD iGPU
-- as its render device: it drives all the outputs, and letting aquamarine
-- enumerate the NVIDIA card first would both wake it permanently and break
-- output assignment. Applications launched with `nvidia-offload` still get the
-- discrete GPU -- this only pins the compositor itself.
hl.env("AQ_DRM_DEVICES", "/dev/dri/by-path/pci-0000:c6:00.0-card")

-- nvidia-vaapi-driver only works outside X with the direct backend. Inert
-- unless a process is started with LIBVA_DRIVER_NAME=nvidia under offload.
hl.env("NVD_BACKEND", "direct")
