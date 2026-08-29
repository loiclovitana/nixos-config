{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.loic = { pkgs, ... }: {
    home.stateVersion = "26.05";

    # cliphist watchers. Run as systemd user services rather than hyprland
    # exec-once: the exec fires before the wlr-data-control interface is ready,
    # so wl-paste --watch exits immediately and nothing is ever stored.
    systemd.user.services = builtins.listToAttrs (map (type: {
      name = "cliphist-${type}";
      value = {
        Unit = {
          Description = "Clipboard history (${type}) via cliphist";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type ${type} --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    }) [ "text" "image" ]);

    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Loïc Vandenberghe";
        user.email = "loiclovitana@gmail.com";
        core.editor = "vim";
        push.autoSetupRemote = true;
        pull.rebase = false;
        init.defaultBranch = "main";
        alias = {
          coma = "commit --amend";
          puf = "push --force-with-lease";
          ada = "!git add -A && git status";
          com = "commit -m";
          undo-amend = "reset --soft HEAD@{1}";
          rema = "pull --rebase origin master";
        };
      };
    };

    programs.bash = {
      enable = true;
      shellAliases = {
        git-clean = ''git fetch --prune && git branch -v | grep "\[gone\]" | grep -v "[\*+]" | awk "{print \$1}" | xargs -I{} git branch -D {}'';
        nix-apply = "sudo nixos-rebuild switch";
        hypr-reload = "hyprctl reload";
	ssh-add-perso = "ssh-add ~/.ssh/id_perso";
      };
    };

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

    xdg.configFile."kitty/kitty.conf".source      = ./kitty/kitty.conf;

    xdg.configFile."waybar/config".source          = ./waybar/config;
    xdg.configFile."waybar/style.css".source       = ./waybar/style.css;
    xdg.configFile."waybar/scripts".source         = ./waybar/scripts;

    # Blueman's own applet duplicates the waybar bluetooth module in the tray.
    # Hide its autostart entry; blueman-manager is still reachable from waybar's on-click.
    xdg.configFile."autostart/blueman.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';
  };
}
