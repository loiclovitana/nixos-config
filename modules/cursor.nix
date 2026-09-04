{ pkgs, ... }:

{
  # Pointer cursor: Catppuccin Latte Red.
  #
  # The theme is installed twice on purpose. Here, system-wide, so anything
  # outside the user session (root/sudo GUI tools, the display manager, apps
  # started from a bare TTY) resolves it through the default XCURSOR_PATH entry
  # /run/current-system/sw/share/icons. The per-user half lives in
  # home/home-manager.nix and is what actually selects the theme.
  environment.systemPackages = [ pkgs.catppuccin-cursors.latteRed  ];

  # GTK4/libadwaita apps read the cursor theme from gsettings rather than from
  # gtk-3.0/settings.ini, and gsettings needs a dconf database to read from.
  # Without this the home-manager gtk module writes keys nothing can consume.
  programs.dconf.enable = true;
}
