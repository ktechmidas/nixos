{ config, pkgs, ... }:

{
  # Disable the internal ASUS laptop keyboard
  # The internal keyboard is identified as "ASUE1403:00 04F3:319A"

  # Method 1: udev rules for libinput
  services.udev.extraRules = ''
    # Disable internal ASUS laptop keyboard by removing it completely
    SUBSYSTEM=="input", ATTRS{name}=="ASUE1403:00 04F3:319A Keyboard", RUN+="${pkgs.coreutils}/bin/rm -f /dev/input/event16"

    # Also try to disable via libinput
    SUBSYSTEM=="input", ATTRS{name}=="ASUE1403:00 04F3:319A Keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"

    # Disable at kernel level
    SUBSYSTEM=="input", KERNEL=="event16", ATTRS{name}=="ASUE1403:00 04F3:319A Keyboard", ATTR{inhibited}="1"

    # Disable Asus Keyboard (USB keyboard)
    SUBSYSTEM=="input", ATTRS{name}=="Asus Keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    SUBSYSTEM=="input", KERNEL=="event18", ATTRS{name}=="Asus Keyboard", ATTR{inhibited}="1"
    # Also match by USB ID
    SUBSYSTEM=="input", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="18c6", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Method 2: systemd service to disable the keyboard after boot
  systemd.services.disable-internal-keyboard = {
    description = "Disable internal ASUS keyboard";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 1 > /sys/devices/platform/AMDI0010:00/i2c-0/i2c-ASUE1403:00/0018:04F3:319A.0006/input/input28/inhibited || true'";
    };
  };
}