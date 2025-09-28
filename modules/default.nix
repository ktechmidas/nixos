{ config, pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./misc.nix
    ./packages.nix
    ./sound.nix
    ./users.nix
    ./podman.nix
    ./impermanence.nix
    ./sops.nix
    ./home-manager.nix
  ];
}
