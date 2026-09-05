{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Graphical boot splash. Adds the "splash" kernel param on its own; kernel
  # messages still print over it unless "quiet" is added too.
  boot.plymouth.enable = true;
}
