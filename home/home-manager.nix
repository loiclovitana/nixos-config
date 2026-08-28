{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.loic = { ... }: {
    home.stateVersion = "26.05";

    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      historyLimit = 10000;
      escapeTime = 0;
      terminal = "screen-256color";
      prefix = "C-Space";
      extraConfig = ''
        set -g renumber-windows on
        setw -g pane-base-index 1

        # New windows/splits open in the current pane's path
        bind c neww -c "#{pane_current_path}"
        bind p split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Window navigation
        bind PageUp selectw -p
        bind PageDown selectw -n
        unbind n
      '';
    };

    xdg.configFile."hypr/hyprland.lua".source     = ./hypr/hyprland.lua;
    xdg.configFile."hypr/monitors.lua".source     = ./hypr/monitors.lua;
    xdg.configFile."hypr/programs.lua".source     = ./hypr/programs.lua;
    xdg.configFile."hypr/autostart.lua".source    = ./hypr/autostart.lua;
    xdg.configFile."hypr/environment.lua".source  = ./hypr/environment.lua;
    xdg.configFile."hypr/permissions.lua".source  = ./hypr/permissions.lua;
    xdg.configFile."hypr/appearance.lua".source   = ./hypr/appearance.lua;
    xdg.configFile."hypr/layouts.lua".source      = ./hypr/layouts.lua;
    xdg.configFile."hypr/misc.lua".source         = ./hypr/misc.lua;
    xdg.configFile."hypr/input.lua".source        = ./hypr/input.lua;
    xdg.configFile."hypr/keybinds.lua".source     = ./hypr/keybinds.lua;
    xdg.configFile."hypr/windowrules.lua".source  = ./hypr/windowrules.lua;
  };
}
