{ pkgs, ... }:

{
  services.fprintd.enable = true;

  # hyprlock leaks the reader's claim when suspending mid-verify
  # (hyprwm/hyprlock#768), wedging fprintd until reboot.
  powerManagement.powerDownCommands = "${pkgs.systemd}/bin/systemctl stop fprintd.service";
  systemd.services.fprintd.serviceConfig.TimeoutStopSec = "5s";
}
