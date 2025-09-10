{
  description = "NixOS flake for this host";

  inputs = {
    # Pin to the current stable NixOS release.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux"; # Matches hardware-configuration.nix
      #We stole this from someone's Git (Krutonium) - it sets up modules and adds an unstable overlay (AFAIK...) which we can then use in the "in" block
      #We could probably make it easier, since we don't really need genericModules as we only run Nix on a single PC...
      genericModules = [ 
        ./configuration.nix
        nixos-hardware.nixosModules.asus-rog-strix-g533q
        ({ config, pkgs, ... }:
          {
            nixpkgs.overlays =
              [
                overlay-unstable
              ];
          }
        )
      ];
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.nvidia.acceptLicense = true;
        };
      };
    in {
      nixosConfigurations = {
        # Hostname matches networking.hostName in configuration.nix
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = genericModules; #No more list, we defined the list above... WHY DOES THIS WORK?!
        };
      };
    };
}

