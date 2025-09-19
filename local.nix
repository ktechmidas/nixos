{ ... }:
{
  # Central place to configure custom toggles.
  # Flip this to false if you want the NVIDIA/GA104 HDA device visible.
  monotoko.sound.disableNvidiaHda = true;

  modules.hyprland-desktop = {
    enable = true;
    user = "monotoko";
    wallpaper = "/home/monotoko/Downloads/skyscraper.png";
  };

  home-manager.users.monotoko = {
    home.stateVersion = "25.05";

    # Override Hyprland monitor configuration
    wayland.windowManager.hyprland.settings.monitor = [
      # HDMI monitor on the left at position 0,0
      "HDMI-A-1,1920x1080@60,0x0,1"
      # Laptop screen on the right at position 1920,0
      "eDP-1,1920x1080@300,1920x0,1"
    ];
  };
}
