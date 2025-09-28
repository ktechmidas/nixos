{
  description = "NixOS flake for this host";

  inputs = {
    # Pin to the current stable NixOS release.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    hyprland-config = {
#      url = "github:ktechmidas/nixos-cachy-hyprland";
#      inputs.nixpkgs.follows = "nixpkgs";
#      inputs.home-manager.follows = "home-manager";
#    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-unstable-small, nixos-hardware, nix-gaming, home-manager, impermanence, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux"; # Matches hardware-configuration.nix
      #We stole this from someone's Git (Krutonium) - it sets up modules and adds an unstable overlay (AFAIK...) which we can then use in the "in" block
      #We could probably make it easier, since we don't really need genericModules as we only run Nix on a single PC...
      genericModules = [
        ./configuration.nix
        nixos-hardware.nixosModules.asus-rog-strix-g533q
        impermanence.nixosModules.impermanence
        sops-nix.nixosModules.sops
        ({ config, pkgs, ... }:
          {
            nixpkgs.overlays =
              [
                overlay-unstable
              ];
          }
        )
        home-manager.nixosModules.home-manager
      ];
      overlay-unstable = final: prev:
        let
          unstable-small-pkgs = import nixpkgs-unstable-small {
            inherit system;
            config.allowUnfree = true;
            config.nvidia.acceptLicense = true;
          };
        in {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            config.nvidia.acceptLicense = true;
          };
          unstable-small = unstable-small-pkgs;
        } // (prev.lib.filterAttrs (n: _: prev.lib.hasPrefix "cosmic-" n) unstable-small-pkgs);
    in {
      nixosConfigurations = {
        # Hostname matches networking.hostName in configuration.nix
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = genericModules; #No more list, we defined the list above... WHY DOES THIS WORK?!
          specialArgs = { inherit nix-gaming; };
        };
      };
    };
}
