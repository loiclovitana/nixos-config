{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.loic = { ... }: {
    home.stateVersion = "26.05";

    xdg.configFile."hypr/hyprland.lua".source = ../hypr/hyprland.lua;
  };
}
