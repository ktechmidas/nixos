{ config, pkgs, lib, ... }:

{
  options.desktop.type = lib.mkOption {
    type = lib.types.enum [ "cosmic" "none" ];
    default = "none";
    description = "Desktop environment to use";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.desktop.type == "cosmic") {
      services.xserver.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    })

    {
      systemd.services.keyboard-backlight = {
        description = "Enable USB keyboard RGB backlight";
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-udev-settle.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "enable-keyboard-backlight" ''
            DEVICE_PATH=$(find /sys/devices -path "*2A7A:9597*/input/input*::scrolllock/brightness" 2>/dev/null | head -1)
            if [ -n "$DEVICE_PATH" ]; then
              echo 1 > "$DEVICE_PATH"
            fi
          '';
          RemainAfterExit = true;
        };
      };
    }
  ];
}
