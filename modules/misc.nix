{ config, pkgs, ... }:
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2a7a", ATTRS{idProduct}=="9597", TAG+="systemd", ENV{SYSTEMD_WANTS}="keyboard-backlight.service"

    ACTION=="add|change", SUBSYSTEM=="leds", ATTRS{idVendor}=="2a7a", ATTRS{idProduct}=="9597", ATTR{brightness}="1"

    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*::scrolllock", ATTRS{idVendor}=="2a7a", ATTRS{idProduct}=="9597", RUN+="${pkgs.bash}/bin/bash -c 'echo 1 > /sys/$devpath/brightness'"
  '';

  services.udev.extraHwdb = ''
    usb:v2A7Ap9597*
     ID_AUTOSUSPEND=0
     ID_PERSIST=1
  '';

  systemd.services.keyboard-backlight = {
    description = "Enable USB keyboard RGB backlight (2A7A:9597)";
    after = [ "multi-user.target" "systemd-udev-settle.service" ];
    wants = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "5s";
      ExecStart = pkgs.writeShellScript "enable-keyboard-backlight" ''
        set -euo pipefail

        found=0
        for attempt in {1..10}; do
          for led in /sys/class/leds/input*::scrolllock; do
            [ -e "$led" ] || continue
            device_path=$(readlink -f "$led" 2>/dev/null || echo "")
            if echo "$device_path" | grep -qi "2A7A:9597"; then
              if [ -w "$led/brightness" ]; then
                echo 1 > "$led/brightness"
                echo "Keyboard backlight enabled: $led"
                found=1
              fi
            fi
          done
          [ $found -eq 1 ] && break
          sleep 1
        done

        [ $found -eq 1 ] || { echo "Failed to find keyboard backlight"; exit 1; }
      '';
    };
  };

  systemd.timers.keyboard-backlight-enforcer = {
    description = "Enforce keyboard backlight state every 30 seconds";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30s";
      OnUnitActiveSec = "30s";
      Unit = "keyboard-backlight-enforcer.service";
    };
  };

  systemd.services.keyboard-backlight-enforcer = {
    description = "Enforce USB keyboard backlight stays on";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "enforce-keyboard-backlight" ''
        for led in /sys/class/leds/input*::scrolllock; do
          [ -e "$led" ] || continue
          device_path=$(readlink -f "$led" 2>/dev/null || echo "")
          if echo "$device_path" | grep -qi "2A7A:9597"; then
            current=$(cat "$led/brightness" 2>/dev/null || echo "0")
            if [ "$current" != "1" ]; then
              echo 1 > "$led/brightness" 2>/dev/null || true
            fi
          fi
        done
      '';
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  time.timeZone = "Indian/Antananarivo";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
}