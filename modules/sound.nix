{ config, lib, pkgs, ... }:

let
  cfg = config.monotoko.sound;
in
{
  # Expose a toggle to hide the NVIDIA/GA104 HDA device in PipeWire (WirePlumber)
  options = {
    monotoko.sound.disableNvidiaHda = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        When true, installs a WirePlumber rule that disables the NVIDIA/GA104
        High Definition Audio Controller so it does not appear in PipeWire/ALSA.
      '';
    };
  };

  config = {
    services.printing.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
      wireplumber = {
        enable = true;
        # Hide/disable the NVIDIA GA104 HDA card from PipeWire/ALSA when enabled
        configPackages = lib.mkIf cfg.disableNvidiaHda [
          (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-disable-nvidia-hda.lua" ''
            -- Disable NVIDIA/GA104 HDA device so it doesn't get exposed
            -- Match any ALSA card whose description mentions NVIDIA/GA104/HDA Controller
            local rule = {
              matches = {
                { { "device.name", "matches", "alsa_card.*" }, { "device.description", "matches", "*NVIDIA*" } },
                { { "device.name", "matches", "alsa_card.*" }, { "device.description", "matches", "*GA104*" } },
                { { "device.name", "matches", "alsa_card.*" }, { "device.description", "matches", "*High Definition Audio Controller*" } },
              },
              apply_properties = {
                ["device.disabled"] = true,
              }
            }

            if alsa_monitor and alsa_monitor.rules then
              table.insert(alsa_monitor.rules, rule)
            end
          '')
        ];
      };
    };
    hardware.pulseaudio.enable = false;
  };
}
