{ ... }:

{
  networking.hostName = "nixos"; # change me
  networking.networkmanager.enable = true;

  # CUPS handles print jobs, while Avahi discovers network printers via mDNS.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Run the daemon and let the desktop user control it through the built-in
  # `tailscale systray` client.
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--operator=loic" ];
  };
}
