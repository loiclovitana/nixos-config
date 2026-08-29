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
