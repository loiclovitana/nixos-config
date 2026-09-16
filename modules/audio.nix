{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # Mic1 (the internal digital mic array) and Mic2 (the 3.5mm headset jack)
    # both come up at session priority 2000, so which one becomes the default
    # source is a coin flip every time the card's profile is re-evaluated —
    # including on resume. Losing the toss selects the unplugged jack, whose
    # analog capture path UCM keeps switched off, and capture goes silent.
    wireplumber.extraConfig."51-internal-mic-priority" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "alsa_input.pci-0000_c6_00.6.HiFi__Mic1__source"; }
          ];
          actions.update-props."priority.session" = 2500;
        }
      ];
    };
  };

  # This card's mic-mute LED wiring lives in the ALSA UCM boot sequence: it
  # creates the "Mic ACP LED Capture Switch" control that the digital mic array
  # mutes through, then moves the LED off the analog "Capture Switch" onto it.
  # Only `alsactl init` runs boot sequences, and PipeWire cannot stand in for it
  # because /sys/class/sound/ctl-led is root-only. Without this the LED tracks
  # an analog path UCM leaves permanently off, so it never goes out.
  systemd.services.alsa-ucm-init = {
    description = "Apply ALSA UCM boot sequence";
    wantedBy = [ "sound.target" ];
    after = [ "sound.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.alsa-utils}/bin/alsactl init";
      SuccessExitStatus = [ 0 99 ];
    };
  };
}
