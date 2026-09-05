{ pkgs, ... }:

{
 
  programs.zsh.enable = true;

  users.users.loic = {
    isNormalUser = true;
    description = "loic";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
  };
}
