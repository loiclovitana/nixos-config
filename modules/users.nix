{ pkgs, ... }:

{
 
  programs.zsh.enable = true;

  users.users.loic = {
    isNormalUser = true;
    description = "user";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
  };
}
