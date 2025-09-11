{ config, pkgs, ... }:


{
  environment.systemPackages = [
  pkgs.discord
  pkgs.slack
  pkgs.vscode
  pkgs.nh
  pkgs.chromium
  pkgs.unstable.codex
  pkgs.boxbuddy
  pkgs.fastfetch
  pkgs.distrobox
  pkgs.filen-desktop
  pkgs.btop
  pkgs.nixfmt-rfc-style
  pkgs.git
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "monotoko" ];
  };

  programs.firefox.enable = true;
}