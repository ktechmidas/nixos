{ config, pkgs, ... }:


{
  environment.systemPackages = [
  pkgs.discord
  pkgs.slack
  pkgs.vscode
  pkgs.nh
  pkgs.chromium
  pkgs.unstable.codex
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "monotoko" ];
  };

  programs.firefox.enable = true;
}