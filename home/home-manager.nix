{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.loic = { pkgs, ... }: let
    # Per-workspace wallpapers. The images themselves live outside this repo,
    # in ~/.local/share/wallpapers, and are managed with `set-wallpaper`. awww draws
    # them: it swaps buffers atomically, so switching does not flash the way
    # hyprpaper did.
    wallpaperApply = pkgs.writeShellApplication {
      name = "hypr-wallpaper-apply";
      runtimeInputs = with pkgs; [ hyprland awww jq coreutils ];
      text = builtins.readFile ./scripts/hypr-wallpaper-apply.sh;
    };
    wallpaperDaemon = pkgs.writeShellApplication {
      name = "hypr-wallpaper-daemon";
      runtimeInputs = with pkgs; [ awww socat coreutils wallpaperApply ];
      text = builtins.readFile ./scripts/hypr-wallpaper-daemon.sh;
    };
    setWallpaper = pkgs.writeShellApplication {
      name = "set-wallpaper";
      runtimeInputs = with pkgs; [ coreutils wallpaperApply ];
      text = builtins.readFile ./scripts/set-wallpaper.sh;
    };
  in {
    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      wallpaperApply wallpaperDaemon setWallpaper
      hyprlock hypridle
      brightnessctl  # hypridle dims the backlight through it
    ];

    # Polkit authentication agent. Without one, any action needing
    # auth_self/auth_admin (fingerprint enrollment, mounting removable media)
    # is denied outright because nothing can prompt for the password.
    services.hyprpolkitagent.enable = true;

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

    # ssh-agent itself is enabled system-wide (modules/ssh.nix). This side only
    # says which key to use and that it should be handed to the agent: the first
    # ssh/git operation of the session prompts for the id_perso passphrase, and
    # every later one reuses the unlocked key. The key file stays outside this
    # repo.
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_perso";
      };
    };

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

        #### Theme: ThinkPad red ####

        # The status line uses the same hex values as kitty/kitty.conf and
        # waybar/style.css: #c8102e (TrackPoint red) as the accent, #f2415b as
        # the bright variant, #000000 background, #e6dadb foreground.
        # `terminal` is screen-256color, so tmux would round the hexes to the
        # 256-colour cube unless the outer terminal is declared truecolor.
        set -as terminal-features ",xterm-kitty:RGB"

        set -g status-style "bg=#000000,fg=#7a5c60"
        set -g status-position bottom
        set -g status-left-length 30
        set -g status-right-length 60

        # Session name in the accent colour, inverted so it reads as a badge.
        set -g status-left "#[fg=#ffffff,bg=#c8102e,bold] #S #[fg=#c8102e,bg=#000000,nobold] "
        set -g status-right "#[fg=#7a5c60] #{host_short} #[fg=#e6dadb]%H:%M "

        # Inactive windows stay muted; the current one takes the accent.
        setw -g window-status-format "#[fg=#7a5c60] #I #W "
        setw -g window-status-current-format "#[fg=#f2415b,bold] #I #W "
        setw -g window-status-activity-style "fg=#f0b968"
        setw -g window-status-bell-style "fg=#f2415b,bold"

        # Pane borders: dark red when idle, full-strength on the active pane.
        set -g pane-border-style "fg=#231315"
        set -g pane-active-border-style "fg=#c8102e"

        # Prompts, copy-mode selection and the message line all reuse the accent.
        set -g message-style "fg=#ffffff,bg=#c8102e"
        set -g message-command-style "fg=#ffffff,bg=#c8102e"
        set -g mode-style "fg=#1f070b,bg=#c8102e"

        set -g display-panes-colour "#231315"
        set -g display-panes-active-colour "#c8102e"

        set -g clock-mode-colour "#c8102e"
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

    # Lock screen and idle daemon. Plain hypr* config, not the home-manager
    # modules, to stay consistent with the rest of this directory.
    xdg.configFile."hypr/hyprlock.conf".source    = ./hypr/hyprlock.conf;
    xdg.configFile."hypr/hypridle.conf".source    = ./hypr/hypridle.conf;

    # Screenshot annotation editor, fed by the Print-key binds in
    # hypr/keybinds.lua. The bare .keep exists so satty's configured
    # output-filename has a directory to write into on the first Ctrl+S --
    # it will not create missing parents itself.
    xdg.configFile."satty/config.toml".source      = ./satty/config.toml;
    home.file."Pictures/Screenshots/.keep".text    = "";

    xdg.configFile."kitty/kitty.conf".source      = ./kitty/kitty.conf;

    xdg.configFile."rofi/config.rasi".source       = ./rofi/config.rasi;

    xdg.configFile."dunst/dunstrc".source          = ./dunst/dunstrc;

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
