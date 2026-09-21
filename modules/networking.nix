{ ... }:

{
  networking.hostName = "nixos"; # change me
  networking.networkmanager.enable = true;

  # Run the daemon and let the desktop user control it through the built-in
  # `tailscale systray` client.
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--operator=loic" ];
  };
}
