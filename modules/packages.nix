{ config, pkgs, lib, nix-gaming, ... }:


{
  environment.systemPackages = [
  pkgs.discord
  pkgs.slack
  pkgs.vscode
  pkgs.nh
  pkgs.chromium
  pkgs.unstable.codex
  pkgs.unstable.claude-code
  pkgs.fastfetch
  pkgs.distrobox
  pkgs.filen-desktop
  pkgs.btop
  pkgs.nixfmt-rfc-style
  pkgs.git
#  nix-gaming.packages.${pkgs.system}.star-citizen
  pkgs.pinta
  pkgs.sshfs
  pkgs.zip
  pkgs.unzip
  pkgs.gamescope
  pkgs.sqlitestudio
  pkgs.xclip
  pkgs.pciutils
  pkgs.cachix
  pkgs.sops
  pkgs.age
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "monotoko" ];
  };

programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; 
    dedicatedServer.openFirewall = false; 
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libkrb5
        keyutils
      ];
    };
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  programs.steam.extraCompatPackages = [
    pkgs.proton-ge-bin
  ];

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
    #nerd-fonts.mplus
    nerd-fonts.symbols-only
    fira
    noto-fonts
    noto-fonts-extra
  ];

}
