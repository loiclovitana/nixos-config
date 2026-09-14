{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
    chromium
    git
    vim
    wget
    waybar
    playerctl
    rofi
    rofimoji
    wtype      # lets rofimoji type the picked emoji into the focused window
    papirus-icon-theme
    yazi
    dunst
    libnotify
    uv
    docker-compose
    pnpm
    spotify
    claude-code
    vscode
    wl-clipboard
    cliphist
    hyprpicker
    grimblast  # screenshot capture (grim/slurp wrapper, Hyprland-aware)
    satty      # screenshot annotation editor
    imv        # image viewer (see xdg.mimeApps in home/home-manager.nix)
    kdePackages.okular  # document/PDF viewer
    awww
    brightnessctl
    pavucontrol
    btop
  ];

  # dynamic loader stub so generic-linux binaries (e.g. uv's downloaded Pythons) run
  programs.nix-ld.enable = true;

  environment.variables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
