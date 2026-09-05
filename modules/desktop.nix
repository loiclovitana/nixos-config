{ pkgs, ... }:

{
  # Hyprland (Wayland)
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  security.polkit.enable = true;

  # hyprlock authenticates through PAM; without its own stack it can never
  # accept a password. Fingerprint unlock is handled by hyprlock itself over
  # fprintd's DBus API, not by this stack, so leave fprintAuth off here --
  # otherwise PAM would also grab the reader and the two would fight over it.
  security.pam.services.hyprlock = {
    fprintAuth = false;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Login manager: greetd + ReGreet (the module runs ReGreet inside cage).
  # Sessions come from desktop files, so hyprland-uwsm.desktop -- installed by
  # programs.hyprland.withUWSM -- shows up in the picker. ReGreet only scans
  # FHS session paths by default, which do not exist here.
  programs.regreet = {
    enable = true;

    # Adwaita-dark as the base; the red palette (kitty/waybar/rofi) is layered
    # on top in extraCss, since GTK themes expose no accent knob.
    theme.name = "Adwaita-dark";

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };

    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaRed;
      name = "catppuccin-mocha-red-cursors";
    };

    # Placeholder gradient, swap the file. The background only covers the
    # monitor; the window colour below shows through wherever it does not.
    settings.background = {
      path = ../assets/greeter-background.png;
      fit = "Cover";
    };

    extraCss = ''
      window {
        background-color: #0c0304;
        color: #e6dadb;
      }
      entry, button {
        background-color: #1e070a;
        color: #e6dadb;
        border-color: #4f4142;
      }
      entry:focus, button:focus, button:hover {
        border-color: #c8102e;
      }
      button:active, selection {
        background-color: #c8102e;
        color: #e6dadb;
      }
    '';
  };
  systemd.services.greetd.serviceConfig.Environment = [
    "SESSION_DIRS=/run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions"
  ];
}
