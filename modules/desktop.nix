{ pkgs, ... }:

{
  # Hyprland (Wayland)
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Login manager: greetd + tuigreet
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };
  # Avoid greeter output being clobbered by kernel messages
  systemd.services.greetd.serviceConfig.Type = "idle";
}
