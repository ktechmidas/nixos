{ config, pkgs, lib, ... }:

{
  options.desktop.type = lib.mkOption {
    type = lib.types.enum [ "cosmic" "gnome" "xfce" "none" ];
    default = "none";
    description = "Desktop environment to use";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.desktop.type != "none") {
      services.xserver.enable = true;
    })

    (lib.mkIf (config.desktop.type == "cosmic") {
      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
    })

    (lib.mkIf (config.desktop.type == "gnome") {
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
    })

    (lib.mkIf (config.desktop.type == "xfce") {
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;
    })
  ];
}
