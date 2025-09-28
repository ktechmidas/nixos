{ config, pkgs, ... }:


{
  users.mutableUsers = false;
  users.users.monotoko = {
    isNormalUser = true;
    description = "monotoko";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    hashedPassword = "$y$j9T$4r2DBt5ZiJGwZJMfe8gfk/$CNY3Y9nW8Sv5iGsCcptGhuiIgReA65S9i95m/TS96L1";
    createHome = false;
    packages = with pkgs; [];
  };
}