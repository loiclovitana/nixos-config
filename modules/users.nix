{ ... }:

{
  users.users.loic = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
  };
}
