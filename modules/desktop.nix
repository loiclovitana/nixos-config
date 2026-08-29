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
