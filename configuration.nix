{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/desktop.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/fprintd.nix
    ./modules/virtualisation.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/ssh.nix
    ./modules/fonts.nix
    ./home/home-manager.nix
  ];

  system.stateVersion = "26.05";
}
