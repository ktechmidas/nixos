{ config, pkgs, ... }:
{
  fileSystems."/mnt" =
    { device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S649NL0TC77828J-part1";
      fsType = "ext4";
    };
}