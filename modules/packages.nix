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
    rofi
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
    brightnessctl
    pavucontrol
  ];

  environment.variables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
